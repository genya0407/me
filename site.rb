require "rakyll"
require "rss"
require 'uri'
require 'net/http'

Encoding.default_external = 'utf-8'

def articles
  blog_atom_url = "https://articles.genya0407.net/feed.xml"
  feed_body = Net::HTTP.get(URI(blog_atom_url))
  atom = RSS::Parser.parse(feed_body)
  atom.items
end

opts = {
  redcarpet_extensions: {
    fenced_code_blocks: true,
    tables: true,
  },
}

Rakyll.dsl opts do
  match "products/*" do
    convert_to_html
    apply "default.html.erb"
  end

  match "salary.md" do
    convert_to_html
    apply "default.html.erb"
  end

  copy "assets/*/*"

  create "index.html" do
    @products = load_all "products/*"
    @products.each { |compiler| compiler.convert_to_html }
    @articles = articles.first(10)
    @title = "About: genya0407"
    apply "index.html.erb"
    apply "default.html.erb"
  end
end
