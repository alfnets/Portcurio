require 'rails_helper'

RSpec.describe "Microposts", type: :system do

  describe "access to root" do
    before do
      @user = FactoryBot.create(:user, :with_posts)
      log_in @user
      visit root_path
    end

    it "has a pagination" do
      expect(page).to have_selector ".pagination"
    end

    it "has 20 posts per page" do
      posts_container = within 'ol.microposts' do
        find_all('li')
      end
      expect(posts_container.length).to eq 20
    end

    it "displays micropost counts" do
      expect(page).to have_content @user.microposts.count.to_s
    end

    it "displays contents of each post" do
      @user.microposts.page(1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end

    it "has a pagination" do
      pagination = find_all(".pagination")
      expect(pagination.length).to eq 1
    end

    describe "of sidebar" do
      it "displays micropost counts" do
        expect(page).to have_content @user.microposts.count.to_s
      end

      it "displays 0 microposts with 0 posts" do
        @user.microposts.destroy_all
        visit current_path
        expect(page).to have_content "0 microposts"
      end

      it "displays 1 micropost with a post" do
        @user.microposts.destroy_all
        fill_in "micropost_content", with: "Test Post"
        click_button "Post"
        expect(page).to have_content "1 micropost"
      end
    end

    describe "then POST a micropost" do

      context "with valid attributes" do
        it "creates a post" do
          aggregate_failures do
            expect {
              fill_in "micropost_content", with: "Test Post"
              click_button "Post"
            }.to change(Micropost, :count).by 1

            expect(page).to have_content "Test Post"
          end
        end

        it "uploads an image" do
          expect {
            fill_in "micropost_content", with: "Test Post"
            attach_file "micropost_image", "#{Rails.root}/spec/fixtures/kitten.jpg"
            click_button "Post"
          }.to change(Micropost, :count).by 1

          attached_post = Micropost.first
          expect(attached_post.image).to be_attached
        end
      end

      context "with invalid attributes" do
        it "doesn't create a post without a content" do
          aggregate_failures do
            expect {
              fill_in "micropost_content", with: ""
              click_button "Post"
            }.not_to change(Micropost, :count)

            expect(page).to have_selector '.error_explanation'
            save_page
            expect(page).to have_link '2', href: '/?micropost%5Bcontent%5D=&page=2'
          end
        end
      end
    end


    describe "of delete micropost buttons" do

      context "as an authorized user" do
        it "are desplayed and available" do
          post = @user.microposts.first
          aggregate_failures do
            expect(page).to have_link "delete"
    
            expect {
              click_link "delete", href: micropost_path(post)
            }.to change(Micropost, :count).by(-1)
    
            expect(page).not_to have_content post.content
          end
        end
      end
  
      context "as an unauthorized user" do
        let(:wrong_user) { FactoryBot.create(:user, :activated) }
  
        it "aren't displayed" do
          visit user_path(wrong_user)
          expect(page).not_to have_link "delete"
        end
      end
    end
  end


  describe "access to users/id" do
    before do
      @user = FactoryBot.create(:user, :with_posts)
      log_in @user
    end

    it "has a pagination" do
      expect(page).to have_selector ".pagination"
    end

    it "has 20 posts per page" do
      posts_container = within 'ol.microposts' do
        find_all('li')
      end
      expect(posts_container.length).to eq 20
    end

    it "displays micropost counts" do
      expect(page).to have_content @user.microposts.count.to_s
    end

    it "displays contents of each post" do
      @user.microposts.page(1).each do |micropost|
        expect(page).to have_content micropost.content
      end
    end

    it "has a pagination" do
      pagination = find_all(".pagination")
      expect(pagination.length).to eq 1
    end
  end
end
