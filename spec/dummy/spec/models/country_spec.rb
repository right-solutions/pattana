require 'spec_helper'

RSpec.describe Country, type: :model do

  let(:country) {FactoryGirl.build(:country)}
  let(:usa) {FactoryGirl.create(:country, name: "United States of America", official_name: "USA", dialing_prefix: "+1", show_in_api: true, operational: true)}
  let(:uae) {FactoryGirl.create(:country, name: "United Arab Emirates", iso_name: "UAE ISO", currency_code: "Dirham")}
  let(:uk) {FactoryGirl.create(:country, name: "United Kingdom", official_name: "UK Official", iso_alpha_2: "A2", iso_alpha_3: "A3")}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:country).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value('Country Name').for(:name )}
    it { should_not allow_value('CT').for(:name )}
    it { should_not allow_value("x"*501).for(:name )}
  end

  context "Associations" do
    it { should have_many(:regions) }
    it { should have_many(:cities) }
  end

  context "Class Methods" do
    it "scope search" do
      arr = [usa, uae, uk]
      
      expect(Country.search("Arab")).to match_array([uae])
      expect(Country.search("Kingdom")).to match_array([uk])
      expect(Country.search("United")).to match_array([usa, uae, uk])

      expect(Country.search("America")).to match_array([usa])
      expect(Country.search("USA")).to match_array([usa])
      expect(Country.search("+1")).to match_array([usa])

      expect(Country.search("UAE ISO")).to match_array([uae])
      expect(Country.search("Dirham")).to match_array([uae])

      expect(Country.search("UK Official")).to match_array([uk])
      expect(Country.search("A2")).to match_array([uk])
      expect(Country.search("A3")).to match_array([uk])
    end

    it "scope show_in_api" do
      expect(Country.show_in_api(true).all).to match_array [usa]
      expect(Country.show_in_api(false).all).to match_array [uae, uk]
    end

    it "scope operational" do
      expect(Country.operational(true).all).to match_array [usa]
      expect(Country.operational(false).all).to match_array [uae, uk]
    end

    context "Import Methods" do
      it "save_row_data" do
        
      end
    end
  end

  context "Instance Methods" do

    context "Permission Methods" do
      it "can_be_edited?" do
        expect(country.can_be_edited?).to be_truthy
      end

      it "can_be_deleted?" do
        expect(country.can_be_deleted?).to be_truthy

        country.operational = true
        country.save
        expect(country.can_be_deleted?).to be_falsy

        region = FactoryGirl.create(:region, name: "Some", country: country)
        expect(country.can_be_deleted?).to be_falsy
      end
    end

    context "Other Methods" do
      it "display_name" do
        expect(usa.display_name).to match("United States of America")
      end

      it "display_show_in_api" do
        c = FactoryGirl.build(:country, show_in_api: false)
        expect(c.display_show_in_api).to match("No")
        c.show_in_api = true
        expect(c.display_show_in_api).to match("Yes")
      end

      it "display_operational" do
        c = FactoryGirl.build(:country, operational: false)
        expect(c.display_operational).to match("No")
        c.operational = true
        expect(c.display_operational).to match("Yes")
      end

      # it "default_image_url" do
      #   u = FactoryGirl.build(:pending_user)
      #   expect(u.default_image_url).to match("/assets/kuppayam/defaults/user-small.png")
      #   expect(u.default_image_url("large")).to match("/assets/kuppayam/defaults/user-large.png")
      # end
    end
  end
  
end