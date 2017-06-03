require 'rakyll'
require 'qiita'

def get_qiita_items
  client = Qiita::Client.new(access_token: ENV['QIITA_ACCESS_TOKEN'])
  client.list_items(query: 'user:genya0407 ').body
end

Rakyll.dsl do
  match 'products/*' do
    apply 'default.html.erb'
  end

  copy 'assets/*/*'

  create 'index.html' do
    @products = load_all 'products/*'
    @qiita_items = get_qiita_items
    @title = "About: Yusuke Sangenya"
    apply 'index.html.erb'
    apply 'default.html.erb'
  end
end
