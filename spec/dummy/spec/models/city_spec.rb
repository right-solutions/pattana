require 'spec_helper'

RSpec.describe City, type: :model do

  let(:city) {FactoryGirl.build(:city)}
  let(:usa) {FactoryGirl.create(:city, name: "United States of America", alternative_names: "US, USA", show_in_api: true)}
  let(:uae) {FactoryGirl.create(:city, name: "United Arab Emirates", alternative_names: "UAE")}
  let(:uk) {FactoryGirl.create(:city, name: "United Kingdom", alternative_names: "UK")}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:city).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value('City Name').for(:name )}
    it { should_not allow_value('CT').for(:name )}
    it { should_not allow_value("x"*501).for(:name )}
  end

  context "Associations" do
    it { should belong_to(:region) }
    it { should belong_to(:country) }
  end

  context "Class Methods" do
    it "search" do
      arr = [usa, uae, uk]
      expect(City.search("America")).to match_array([usa])
      expect(City.search("US")).to match_array([usa])
      expect(City.search("USA")).to match_array([usa])
      expect(City.search("Arab")).to match_array([uae])
      expect(City.search("UAE")).to match_array([uae])
      expect(City.search("Kingdom")).to match_array([uk])
      expect(City.search("UK")).to match_array([uk])
      expect(City.search("United")).to match_array([usa, uae, uk])
    end

    it "scope show_in_api" do
      expect(City.show_in_api.all).to match_array [usa]
    end

    context "Import Methods" do
      it "save_row_data" do
        skip "To Be Implemented"
      end
    end
  end

  context "Instance Methods" do

    context "Permission Methods" do
      it "can_be_edited?" do
        expect(city.can_be_edited?).to be_falsy
      end

      it "can_be_deleted?" do
        expect(city.can_be_deleted?).to be_falsy
      end
    end

    context "Other Methods" do
      it "display_name" do
        expect(usa.display_name).to match("United States of America")
      end

      it "display_show_in_api" do
        c = FactoryGirl.build(:city, show_in_api: false)
        expect(c.display_show_in_api).to match("No")
        c.show_in_api = true
        expect(c.display_show_in_api).to match("Yes")
      end

      it "default_image_url" do
        #u = FactoryGirl.build(:pending_user)
        #expect(u.default_image_url).to match("/assets/kuppayam/defaults/user-small.png")
        #expect(u.default_image_url("large")).to match("/assets/kuppayam/defaults/user-large.png")
      end
    end
  end
  
end