require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }
  let(:from_address) { "noreply@mail.#{domain_name}" }
  
  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(user) }

    before { user.activation_token = User.new_token }

    it "sends to the user's email address" do
      expect(mail.to).to eq [user.email]
    end

    it "sends with the correct subject" do
      expect(mail.subject).to eq("Account activation")
    end

    it "sends from the correct email address" do
      expect(mail.from).to eq [from_address]
    end

    describe "body" do
      context "as html" do
        it "includes the user's name" do
          expect(mail.html_part.body.encoded).to match(user.name)
        end

        it "includes the user's email" do
          expect(mail.html_part.body.encoded).to match(CGI.escape(user.email))
        end

        it "includes the activation token" do
          expect(mail.html_part.body.encoded).to match(user.activation_token)
        end
      end

      context "as text" do
        it "includes the user's name" do
          expect(mail.text_part.body.encoded).to match(user.name)
        end

        it "includes the user's email" do
          expect(mail.text_part.body.encoded).to match(CGI.escape(user.email))
        end

        it "includes the activation token" do
          expect(mail.text_part.body.encoded).to match(user.activation_token)
        end
      end
    end
  end


  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(user) }

    before { user.reset_token = User.new_token }

    describe "header" do
      it "sends to the user's email address" do
        expect(mail.to).to eq [user.email]
      end

      it "sends with the correct subject" do
        expect(mail.subject).to eq("Password reset")
      end

      it "sends from the correct email address" do
        expect(mail.from).to eq [from_address]
      end
    end

    describe "body" do
      context "as html" do
        it "includes the user's email" do
          expect(mail.html_part.body.encoded).to match(CGI.escape(user.email))
        end

        it "includes the reses token" do
          expect(mail.html_part.body.encoded).to match(user.reset_token)
        end
      end

      context "as text" do
        it "includes the user's email" do
          expect(mail.text_part.body.encoded).to match(CGI.escape(user.email))
        end

        it "includes the reses token" do
          expect(mail.text_part.body.encoded).to match(user.reset_token)
        end
      end
    end
  end
end
