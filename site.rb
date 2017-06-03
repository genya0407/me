require 'rakyll'
require 'qiita'

def get_qiita_items
  client = Qiita::Client.new(access_token: ENV['QIITA_ACCESS_TOKEN'])
  client.list_items(query: 'user:genya0407 ').body
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
    @qiita_items = get_qiita_items
    @title = "About: Yusuke Sangenya"
    apply 'index.html.erb'
    apply 'default.html.erb'
  end
end
