require 'erb'
require 'yaml'
require 'pathname'
require 'fileutils'
require 'redcarpet'
require 'qiita'

module Rakyll
end

class Rakyll::Route
  def initialize
    @compilers = []
  end

  def match(pattern, &block)
    Dir.glob(pattern).each do |source_filename|
      compiler = Rakyll::Compiler::Match.new source_filename
      compiler.instance_eval &block
      @compilers.push compiler
    end
  end

  def copy(pattern)
    Dir.glob(pattern).each do |source_filename|
      compiler = Rakyll::Compiler::Copy.new source_filename
      @compilers.push compiler
    end
  end

  def create(filename, &block)
    compiler = Rakyll::Compiler::Create.new filename
    compiler.instance_eval &block
    @compilers.push compiler
  end

  def save
    @compilers.each do |compiler|
      compiler.save
    end
  end
end

module Rakyll::Compiler
  module Apply
    def apply(template_name)
      template_string = File.read('templates/' + template_name)
      @body = ERB.new(template_string).result(binding)
    end
  end

  module SetFilename
    def set_filename(source_filename, ext = nil)
      pathname = Pathname.new(source_filename)
      pathname = pathname.sub_ext(ext) unless ext.nil?
      @url = '/' + pathname.to_s
      @filename = '_site/' + pathname.to_s
      FileUtils.mkdir_p(File.dirname(@filename))
    end
  end
end

module Rakyll::Compiler
  class Copy
    include SetFilename

    def initialize(source_filename)
      @source_filename = source_filename
      set_filename(source_filename)
    end

    def save
      FileUtils.copy(@source_filename, @filename)
    end
  end
end

module Rakyll::Compiler
  class Match
    include Apply
    include SetFilename
    attr_reader :body, :url

    def initialize(source_filename)
      @source_filename = source_filename
      metadata_string, markdown_string = File.read(@source_filename).split("---\n")
      set_metadata_from_yaml(metadata_string)
      set_body_from_markdown(markdown_string)
      set_filename(source_filename, '.html')
    end

    def save
      File.write(@filename, @body)
    end

    private
    def set_metadata_from_yaml(metadata_string)
      YAML.load(metadata_string).each do |key, value|
        instance_variable_set(:"@#{key}", value)
        singleton_class.class_eval { attr_reader key }
      end
    end

    def set_body_from_markdown(markdown_string)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      @body = markdown.render(markdown_string)
    end
  end
end

module Rakyll::Compiler
  class Create
    include Apply
    include SetFilename
    attr_reader :url

    def initialize(source_filename)
      @source_filename = source_filename
      set_filename(source_filename)
    end

    def load_all(pattern)
      Dir.glob(pattern).map do |filename|
        Match.new filename
      end
    end

    def save
      File.write(@filename, @body)
    end
  end
end

def dsl(&block)
  route = Rakyll::Route.new
  route.instance_eval &block
  route.save
end

def get_qiita_items
  client = Qiita::Client.new(access_token: ENV['QIITA_ACCESS_TOKEN'])
  client.list_items(query: 'user:genya0407 ').body
end

dsl do
  match 'products/*' do
    apply 'product.html.erb'
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
