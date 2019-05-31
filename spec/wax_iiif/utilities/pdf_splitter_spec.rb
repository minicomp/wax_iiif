require 'spec_helper'


describe WaxIiif::Utilities::PdfSplitter do
  context 'comparing' do
    it 'generates the proper number of files' do
      skip('skipping expensive tests') if ENV['SKIP_EXPENSIVE_TESTS']
      dir = './pdf_temp'
      Dir.mkdir dir
      results = WaxIiif::Utilities::PdfSplitter.split('./spec/data/test.pdf', output_dir: dir)
      expect(results.count).to eq(3)
    end
  end
end
