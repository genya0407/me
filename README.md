
# how to generate site

```shell
$ export QIITA_ACCESS_TOKEN='~~~~~'
$ bundle install
$ bundle exec ruby site.rb
$ bundle exec ruby -run -e httpd ./_site -p 8080 
```
