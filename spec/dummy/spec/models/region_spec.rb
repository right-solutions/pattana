require 'spec_helper'

RSpec.describe Region, type: :model do

  let(:country) {FactoryGirl.build(:country, name: "India")}
  let(:region) {FactoryGirl.build(:region)}
  let(:mp) {FactoryGirl.create(:region, name: "Madhya Pradesh", country: country, show_in_api: true, operational: true)}
  let(:up) {FactoryGirl.create(:region, name: "Uttar Pradesh", country: country)}
  let(:hp) {FactoryGirl.create(:region, name: "Himachal Pradesh", country: country)}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:region).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value('Region Name').for(:name )}
    it { should_not allow_value('R').for(:name )}
    it { should_not allow_value("x"*501).for(:name )}
  end

  context "Associations" do
    it { should belong_to(:country) }
    it { should have_many(:cities) }
  end

  context "Class Methods" do
    it "search" do
      arr = [mp, up, hp]
      expect(Region.search("Madhya")).to match_array([mp])
      expect(Region.search("Uttar")).to match_array([up])
      expect(Region.search("Himachal")).to match_array([hp])
      expect(Region.search("Pradesh")).to match_array([mp, up, hp])
      
      expect(Region.search("India")).to match_array([mp, up, hp])
    end

    it "scope show_in_api" do
      expect(Region.show_in_api(true).all).to match_array [mp]
      expect(Region.show_in_api(false).all).to match_array [up, hp]
    end

    it "scope operational" do
      expect(Region.operational(true).all).to match_array [mp]
      expect(Region.operational(false).all).to match_array [up, hp]
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
        expect(region.can_be_edited?).to be_truthy
      end

      it "can_be_deleted?" do
        expect(region.can_be_deleted?).to be_truthy

        region.operational = true
        region.save
        expect(region.can_be_deleted?).to be_falsy

        city = FactoryGirl.create(:city, name: "Some", region: region, country: region.country)
        expect(region.can_be_deleted?).to be_falsy
      end
    end

    context "Other Methods" do
      it "display_name" do
        expect(mp.display_name).to match("Madhya Pradesh")
      end

      it "display_show_in_api" do
        r = FactoryGirl.build(:region, show_in_api: false)
        expect(r.display_show_in_api).to match("No")
        r.show_in_api = true
        expect(r.display_show_in_api).to match("Yes")
      end

      it "display_operational" do
        r = FactoryGirl.build(:region, operational: false)
        expect(r.display_operational).to match("No")
        r.operational = true
        expect(r.display_operational).to match("Yes")
      end

      it "default_image_url" do
        #u = FactoryGirl.build(:pending_user)
        #expect(u.default_image_url).to match("/assets/kuppayam/defaults/user-small.png")
        #expect(u.default_image_url("large")).to match("/assets/kuppayam/defaults/user-large.png")
      end
    end
  end
  
end