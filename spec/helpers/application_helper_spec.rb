require 'rails_helper'
 
RSpec.describe ApplicationHelper, type: :helper do

  describe "full_title method" do
    let(:site_name) { "Test Site" }
 
    context "exists parameter" do
      it "returns 'parameter | site_name'" do
        expect(full_title("Page Title")).to eq "Page Title | #{site_name}"
      end
    end
 
    context "doesn't exist parameter" do
      it "returns 'site_name'" do
        expect(full_title).to eq "#{site_name}"
      end
    end
  end
end