bundle install --path vendor/bundle
bundle exec ruby site.rb && \
scp -r ./_site/* kuminecraft.xyz:/var/portfolio
