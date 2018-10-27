require 'spec_helper'
require 'base_properties_spec'

describe WaxIiif::Collection do
  let (:labeled_config) { WaxIiif::Config.new(collection_label: 'test') }
  let (:config) { WaxIiif::Config.new }
  context 'base' do
    before(:each) do
      @object         = WaxIiif::Collection.new(labeled_config)
      @labeled_object = WaxIiif::Collection.new(config)
    end
    it_behaves_like 'base properties'
  end

  context 'initialization' do
    it 'initializes without issues when given a label' do
      collection = nil
      expect{ collection = WaxIiif::Collection.new(labeled_config) }.not_to raise_error
      expect(collection.id).to eq('http://0.0.0.0/collection/test.json')
    end
    it 'initializes with default label when none is specified' do
      collection = WaxIiif::Collection.new(config)
      expect(collection.id).to include 'top.json'
    end
  end
  context 'data init' do
    include_context('fake data')
    let(:collection) { WaxIiif::Collection.new(labeled_config) }
    let(:manifest) { WaxIiif::Manifest.new(@fake_data[0,2], config) }
    it 'has a label' do
      expect(collection.label).to eq 'test'
    end
    it 'has an id' do
      expect(collection.id).to eq 'http://0.0.0.0/collection/test.json'
    end

    it 'allows you to add a collection' do
      newCollection = collection.clone
      expect{ collection.add_collection(newCollection) }.not_to raise_error
    end

    it 'fails if you add something else to a collection' do
      newCollection = {}
      expect{ collection.add_collection(newCollection) }.to raise_error(WaxIiif::Error::NotACollection)
    end


    it 'generates correct JSON' do
      collection.add_manifest(manifest)
      expect(collection.to_json.delete(" \t\r\n")).to eq @fake_collection
    end
  end
end
