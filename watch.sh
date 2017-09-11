bundle exec ruby site.rb
bundle exec filewatcher index.html products/* assets/*/* templates/* site.rb "bundle exec ruby site.rb" &
ruby -rwebrick -e 'WEBrick::HTTPServer.new(:DocumentRoot => "./_site", :Port => 8000).start'
