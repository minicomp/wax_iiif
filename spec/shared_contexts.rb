RSpec.shared_context "fake variants" do
  before(:example) do
    @fake_variants = {
      "full" => OpenStruct.new(:id => "http://www.example.com/images/1", :width => 1000, :height => 1200),
      "thumbnail" => OpenStruct.new(:id => "http://www.example.com/images/1", :width => 100, :height => 120)
    }
    @fake_image_info = '{"@context":"http://iiif.io/api/image/2/context.json","@id":"http://www.example.com/test/1","protocol":"http://iiif.io/api/image","width":1000,"height":1200,"sizes":[{"width":1000,"height":1200},{"width":100,"height":120}],"profile":["http://iiif.io/api/image/2/level0.json",{"supports":["cors","sizeByWhListed","baseUriRedirect"]}]}'
  end
end

RSpec.shared_context "fake data" do
  include_context("fake variants")
  before(:example) do

    @fake_collection = '{"@context":"http://iiif.io/api/presentation/2/context.json","@id":"http://0.0.0.0/collection/test.json","@type":"sc:Collection","label":"test","manifests":[{"@id":"http://0.0.0.0/1/manifest.json","@type":"sc:Manifest","label":"testlabel"}]}'

    @fake_data = [ WaxIiif::ImageRecord.new({
      "manifest_id" => 1,
      "id" => 1,
      "image_path" => "./spec/data/test.jpg",
      "is_primary" => true,
      "variants" => @fake_variants,
      "label" => "test label",
      "attribution" => "All rights reserved",
      "logo" => "http://www.example.com/logo.jpg"
    }),
    WaxIiif::ImageRecord.new({
      "manifest_id" => 1,
      "id" => 2,
      "image_path" => "./spec/data/test.jpg",
      "is_primary" => false,
      "variants" => @fake_variants,
      "label" => "test label",
      "attribution" => "All rights reserved",
      "logo" => "http://www.example.com/logo.jpg"
    }),
    WaxIiif::ImageRecord.new({
      "id" => 3,
      "image_path" => "./spec/data/test.jpg",
      "is_primary" => true,
      "variants" => @fake_variants,
      "label" => "test label",
      "attribution" => "All rights reserved",
      "logo" => "http://www.example.com/logo.jpg"
    })]

    @fake_manifest_1 = '{"@context":"http://iiif.io/api/presentation/2/context.json","@id":"http://0.0.0.0/1/manifest.json","@type":"sc:Manifest","label":"testlabel","attribution":"Allrightsreserved","logo":"http://www.example.com/logo.jpg","thumbnail":"http://www.example.com/images/1/full/100,/0/default.jpg","viewingDirection":"left-to-right","viewingHint":"individuals","sequences":[{"@id":"http://0.0.0.0/sequence/1.json","@type":"sc:Sequence","canvases":[{"@type":"sc:Canvas","@id":"http://0.0.0.0/canvas/1.json","label":"front","width":2000,"height":2400,"thumbnail":"http://www.example.com/images/1/full/100,/0/default.jpg","images":[{"@type":"oa:Annotation","@id":"http://0.0.0.0/annotation/1.json","motivation":"sc:painting","resource":{"@id":"http://www.example.com/images/1/full/full/0/default.jpg","@type":"dcterms:Image","format":"image/jpeg","service":{"@context":"http://iiif.io/api/image/2/context.json","@id":"http://www.example.com/images/1","profile":"http://iiif.io/api/image/2/level0.json"},"width":1000,"height":1200},"on":"http://0.0.0.0/canvas/1.json"}]},{"@type":"sc:Canvas","@id":"http://0.0.0.0/canvas/2.json","label":"front","width":2000,"height":2400,"thumbnail":"http://www.example.com/images/1/full/100,/0/default.jpg","images":[{"@type":"oa:Annotation","@id":"http://0.0.0.0/annotation/2.json","motivation":"sc:painting","resource":{"@id":"http://www.example.com/images/1/full/full/0/default.jpg","@type":"dcterms:Image","format":"image/jpeg","service":{"@context":"http://iiif.io/api/image/2/context.json","@id":"http://www.example.com/images/1","profile":"http://iiif.io/api/image/2/level0.json"},"width":1000,"height":1200},"on":"http://0.0.0.0/canvas/2.json"}]}]}]}'

    @fake_manifest_3 = '{"@context":"http://iiif.io/api/presentation/2/context.json","@id":"http://0.0.0.0/3/manifest.json","@type":"sc:Manifest","label":"testlabel","attribution":"Allrightsreserved","logo":"http://www.example.com/logo.jpg","thumbnail":"http://www.example.com/images/1/full/100,/0/default.jpg","viewingDirection":"left-to-right","viewingHint":"individuals","sequences":[{"@id":"http://0.0.0.0/sequence/3.json","@type":"sc:Sequence","canvases":[{"@type":"sc:Canvas","@id":"http://0.0.0.0/canvas/3.json","label":"front","width":2000,"height":2400,"thumbnail":"http://www.example.com/images/1/full/100,/0/default.jpg","images":[{"@type":"oa:Annotation","@id":"http://0.0.0.0/annotation/3.json","motivation":"sc:painting","resource":{"@id":"http://www.example.com/images/1/full/full/0/default.jpg","@type":"dcterms:Image","format":"image/jpeg","service":{"@context":"http://iiif.io/api/image/2/context.json","@id":"http://www.example.com/images/1","profile":"http://iiif.io/api/image/2/level0.json"},"width":1000,"height":1200},"on":"http://0.0.0.0/canvas/3.json"}]}]}]}'
  end
end
