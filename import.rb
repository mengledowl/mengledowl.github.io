

require "jekyll-import";
JekyllImport::Importers::WordpressDotCom.run({
  "source" => "/Users/mattengledowl/downloads/graphqlme.WordPress.2022-08-06.xml",
  "no_fetch_images" => false,
  "assets_folder" => "assets/images"
})
