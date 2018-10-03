require 'spec_helper'


describe WaxIiif::Config do
  context 'comparing' do
    it 'shows equal things to be equal' do
      expect(WaxIiif::Config.new).to eq(WaxIiif::Config.new)
    end
    it 'shows different things to be different' do
      opts = {tile_width: 99, upload_to_s3: false}
      opts2 = {tile_width: 100, upload_to_s3: false}
      expect(WaxIiif::Config.new opts).not_to eq(WaxIiif::Config.new opts2)
    end
  end
end
