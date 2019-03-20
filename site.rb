require 'rakyll'
require 'qiita'
require 'rss'

def get_qiita_items
  client = Qiita::Client.new(access_token: ENV['QIITA_ACCESS_TOKEN'])
  client.list_items(query: 'user:genya0407').body
end

def get_blog_items
  blog_rss_url = 'http://dawn.hateblo.jp/rss'
  rss = RSS::Parser.parse(blog_rss_url)
  rss.channel.items
end

opts = {
  redcarpet_extensions: {
    fenced_code_blocks: true
  }
}

Rakyll.dsl opts do
  match 'products/*' do
    convert_to_html
    apply 'default.html.erb'
  end

  copy 'assets/*/*'

  create 'index.html' do
    @products = load_all 'products/*'
    @products.each { |compiler| compiler.convert_to_html }
    @qiita_items = get_qiita_items.first(5)
    @blog_items = get_blog_items.first(5)
    @title = "About: genya0407"
    apply 'index.html.erb'
    apply 'default.html.erb'
  end
end
