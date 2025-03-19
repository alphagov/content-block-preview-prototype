require 'nokogiri'
require 'sinatra'

require './lib/snippet_builder'

set :static_cache_control, [:public, max_age: 0]

get '/' do
  erb :index
end

get '/preview' do
  @tab = params["tab"] || "instances"
  @path = params["path"]
  @html = File.read(File.join("html", @path))

  snippet_builder = SnippetBuilder.new(@html)

  @back_link = "/"
  @title = snippet_builder.title
  @instances = snippet_builder.instances

  if @tab == "instances"
    @results = snippet_builder.results
  end

  erb :preview
end
