require 'nokogiri'
require 'sinatra'

require './lib/snippet_builder'

set :static_cache_control, [:public, max_age: 0]

get '/' do
  erb :index
end

get '/preview' do
  html = File.read(File.join("html", params["path"]))
  snippet_builder = SnippetBuilder.new(html)

  @back_link = "/"
  @title = snippet_builder.title
  @instances = snippet_builder.instances
  @results = snippet_builder.results

  erb :preview
end
