FactoryBot.define do
  factory :flag_image, :class => Image::FlagImage do
    image { Rack::Test::UploadedFile.new('spec/dummy/spec/factories/flag.png', 'image/jpg') }
    association :imageable, :factory => :country
  end
end
