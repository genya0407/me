require "rakyll"
require "rss"

def articles
  blog_atom_url = "https://articles.kuminecraft.xyz/feed.xml"
  atom = RSS::Parser.parse(blog_atom_url)
  atom.items
end

opts = {
  redcarpet_extensions: {
    fenced_code_blocks: true,
  },
}

Rakyll.dsl opts do
  match "products/*" do
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
