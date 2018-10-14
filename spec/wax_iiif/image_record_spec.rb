 require 'spec_helper'
 require 'base_properties_spec'


describe WaxIiif::ImageRecord do
  let(:opts) {{
      id: 1
    }}
    let(:image_record) {WaxIiif::ImageRecord.new(opts)}

  it 'initializes without an error' do
    expect{WaxIiif::ImageRecord.new}.not_to raise_error
  end
  it 'initializes without an error when provided a hash' do
    opts = {id: 1}
    expect{WaxIiif::ImageRecord.new(opts)}.not_to raise_error
  end

  context '#viewing_direction' do
    it 'has a sensible default' do
      expect(image_record.viewing_direction).to eq WaxIiif::DEFAULT_VIEWING_DIRECTION
    end

    it 'rejects invalid viewing directions on init' do
      opts = {viewing_direction: 'wonky'}
      expect{WaxIiif::ImageRecord.new(opts)}.to raise_error(WaxIiif::Error::InvalidViewingDirection)
    end

    it 'rejects setting invalid viewing directions' do
      expect{image_record.viewing_direction = 'wonky'}.to raise_error(WaxIiif::Error::InvalidViewingDirection)
    end
  end

  it 'initializes with provided hash values' do
    expect(image_record.id).to eq opts[:id]
  end
  it 'ignores unknown data' do
    opts['junk_data'] = 'bozo'
    expect{WaxIiif::ImageRecord.new(opts)}.not_to raise_error
  end
  context '#is_primary' do
    it 'defaults to false' do
      expect(image_record.primary?).to equal(false)
    end
    it 'forces is_primary to boolean' do
      image_record.is_primary = 'banana'
      expect(image_record.primary?).to equal(true)
    end
    it 'allows page_number default to be overridded' do
      image_record.is_primary = false
      expect(image_record.primary?).to equal(false)
    end
  end
  context '#image_path' do
    it 'raises on a blan path' do
      expect{image_record.path = nil}.to raise_error(WaxIiif::Error::InvalidImageData)
    end
    it 'raises an error for a bad file name' do
      expect{image_record.path = 'imaginary_file.jpg'}.to raise_error(WaxIiif::Error::InvalidImageData)
    end
  end
  context '#section' do
    it 'uses the default for the name' do
      expect(image_record.section).to eq WaxIiif::DEFAULT_CANVAS_LABEL
    end
    it 'uses the default for the label' do
      expect(image_record.section_label).to eq WaxIiif::DEFAULT_CANVAS_LABEL
    end
  end
  context '#is_document' do
    it 'defaults to false' do
      expect(image_record.document?).to equal(false)
    end
    it 'has_an_alias' do
      expect(image_record.document?).to equal(false)
    end
    it 'forces is_document to boolean' do
      image_record.is_document = 'banana'
      expect(image_record.document?).to equal(true)
    end
  end
end
