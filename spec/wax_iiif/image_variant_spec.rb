require 'spec_helper'

describe WaxIiif::ImageVariant do
  let(:config) {WaxIiif::Config.new}
  let(:data) { WaxIiif::ImageRecord.new({
    'path' => './spec/data/test.jpg',
    'id' => 1})
  }

  context 'initialization errors' do
    it 'raises if the image does not have an ID' do
      data.id =nil
      expect{WaxIiif::ImageVariant.new(data, config)}.to raise_error(WaxIiif::Error::InvalidImageData)
    end
    it 'raises if the image has a blank ID' do
      data.id = ''
      expect{WaxIiif::ImageVariant.new(data, config)}.to raise_error(WaxIiif::Error::InvalidImageData)
    end

    it 'raises if the image is not a valid image file' do
      data.path = './spec/data/test.csv'
      expect{WaxIiif::ImageVariant.new(data, config)}.to raise_error(WaxIiif::Error::InvalidImageData)
    end

  end

  context 'basic data' do
    before(:all) do
      data = WaxIiif::ImageRecord.new({
        'path' => './spec/data/test.jpg',
        'id' => 1
      })
      config = WaxIiif::Config.new
      @img = WaxIiif::ImageVariant.new(data, config, 100)
    end

    it 'has a uri' do
      expect(@img.uri).to eq("#{@img.generate_image_id(1)}/full/100,/0/default.jpg")
    end
    it 'has an id' do
      expect(@img.id).to eq(@img.generate_image_id(1))
    end
    it 'has a width' do
      expect(@img.width).to eq(100)
    end
    it 'has a mime type' do
      expect(@img.mime_type).to eq('image/jpeg')
    end
  end

  context 'Full Image' do
    before(:all) do
      data = WaxIiif::ImageRecord.new({
        'path' => './spec/data/test.jpg',
        'id' => 1,
        'page_number' => 1
      })
       config = WaxIiif::Config.new
       @img = WaxIiif::FullImage.new(data, config)
    end
    it 'has the default filestring' do
      expect(@img.uri).to include 'full/full'
    end

  end
end
