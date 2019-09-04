require 'spec_helper'
require 'ostruct'
require 'fileutils'

describe WaxIiif::Builder do
  let (:iiif) { WaxIiif::Builder.new() }
  let (:test_object_0) { WaxIiif::ImageRecord.new({'id' => 'img1' }) }
  let (:test_object_1) { WaxIiif::ImageRecord.new({'id' => 'img2', 'manifest_id' => 'm1'}) }
  let (:test_object_2) { WaxIiif::ImageRecord.new({'id' => 'img3', 'manifest_id' => 'm1' }) }
  let (:test_object_2) { WaxIiif::ImageRecord.new({'id' => 'img4', 'manifest_id' => 'm2' }) }
  let (:data) {[test_object_0, test_object_1,test_object_2]}

  context 'When initializing' do
    it 'generates manifests' do
      expect(iiif.manifests).to eq(Array.new)
    end
    it 'uses the default config' do
      expect(iiif.config).to eq(WaxIiif::Config.new)
    end
    it 'will accept a configuration hash' do
      opts = {tile_width: 99}
      iiif2 = WaxIiif::Builder.new(opts)
      expect(iiif2.config.tile_width).to eq(99)
    end
  end

  context 'loading data' do
    it 'will accept an array of objects' do
      iiif.load(data)
      expect(iiif.data).to eq(data)
    end
    it 'will accept a single object' do
      iiif.load(test_object_1)
      expect(iiif.data).to eq([test_object_1])
    end

    it 'will error if the data is bad' do
      expect{iiif.load({random: 'hash'})}.to raise_error(WaxIiif::Error::InvalidImageData)
      expect{iiif.load([{random: 'hash'}])}.to raise_error(WaxIiif::Error::InvalidImageData)
    end
  end

  context 'when processing data' do
    include_context('fake variants')
    include_context('fake data')

    before(:example) do
      @iiif = WaxIiif::Builder.new({base_url: 'http://0.0.0.0', verbose: false, thumbnail_size: 120})
      @iiif.load(@fake_data)
      allow(@iiif).to receive(:generate_tiles) {nil}
      allow(@iiif).to receive(:generate_variants) {@fake_variants}
    end
    it 'does not fail with no data' do
      expect {iiif.process_data}.not_to raise_error
    end

    it 'does not fail with real data' do
      expect {@iiif.process_data}.not_to raise_error
    end

    it ' passes the Temporary Manifest Check' do
      @iiif.process_data
      expect(@iiif.manifests.count).to eq 2
      # expect(@iiif.manifests.first.to_json.delete(" \t\r\n")).to eq @fake_manifest_1
      # expect(@iiif.manifests.last.to_json.delete(" \t\r\n")).to eq @fake_manifest_3
    end
  end


  context 'when dealing with already loaded data' do
    include_context('fake data')
    include_context('fake variants')

    before(:example) do
      @dir = Dir.mktmpdir
      @iiif = WaxIiif::Builder.new({output_dir: @dir, base_url: 'http://0.0.0.0', verbose: false, thumbnail_size: 120})
      @iiif.load(@fake_data)
      @info_json = "#{@dir}/images/1/info.json"
      allow(@iiif).to receive(:generate_tiles) {nil}
      allow(@iiif).to receive(:generate_variants) {@fake_variants}
      @iiif.process_data
    end

    after(:example) do
      FileUtils.remove_entry @dir
    end

    it 'has the temporary file' do
      expect(File.exist?(@info_json)).to eq true
    end

   it 'does try to generate images if that file is missing' do
      File.delete(@info_json)
      @iiif.process_data
      expect(@iiif).to have_received(:generate_tiles).exactly(4).times
      expect(@iiif).to have_received(:generate_variants).exactly(4).times
    end

    it 'does not try to generate images if that file is present' do
      @iiif.process_data
      expect(@iiif).to have_received(:generate_tiles).exactly(3).times
      expect(@iiif).to have_received(:generate_variants).exactly(3).times
    end

    it 'generates the correct manifest anyway' do
      @iiif.process_data
      expect(@iiif.manifests.count).to eq 2
      # expect(@iiif.manifests.first.to_json.delete(" \t\r\n")).to eq @fake_manifest_1
    end

  end

  context 'When load_csving CSV files' do
    it 'accepts a path' do
      expect{iiif.load_csv('./spec/data/test.csv')}.not_to raise_error()
    end
    it 'fails on blank CSV files' do
      expect{iiif.load_csv('./spec/data/blank.csv')}.to raise_error(WaxIiif::Error::BlankCSV)
    end
    it 'fails on invalid CSV files' do
      expect{iiif.load_csv('./spec/data/invalid.csv')}.to raise_error(WaxIiif::Error::InvalidCSV)
    end
    it 'fails on missing CSV files' do
      expect{iiif.load_csv('./spec/data/i_dont_exist.csv')}.to raise_error(WaxIiif::Error::InvalidCSV)
    end
  end

  context 'When loading a CSV file' do
    it 'saves the data into the @data param' do
      expect(iiif.data).to be_nil
      iiif.load_csv('./spec/data/test.csv')
      expect(iiif.data).not_to be_nil
    end
    it 'removes headers' do
      iiif.load_csv('./spec/data/test.csv')
      expect(iiif.data[0]['image_path']).to eq('spec/data/test.jpg')
    end
    it "doesn't remove headers if not present" do
      iiif.load_csv('./spec/data/no_header.csv')
      expect(iiif.data[0]['image_path']).to eq('spec/data/test.jpg')
    end
  end
end
