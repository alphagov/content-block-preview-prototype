require 'nokogiri'
require 'sinatra'

set :static_cache_control, [:public, max_age: 0]

get '/' do
  erb :index
end

get '/preview' do
  html = File.read(File.join("html", params["path"]))
  doc = Nokogiri::HTML(html)
  embeds = doc.css(".content-embed")
  @back_link = "/"
  @title = doc.at_css("h1").inner_text
  @instances = embeds.count

  @results = embeds.map { |embed|
    next if embed.nil?

    parent = embed.parent
    if parent.name == "li"
      parent = parent.parent
    end
    if parent.name == "div"
      parent = parent.parent
    end

    parent_elements = [
      parent.previous_element&.previous_element,
      parent.previous_element,
    ].compact

    next_elements = [
      parent.next_element,
      parent.next_element&.next_element,
    ].compact

    [parent_elements, next_elements].flatten.each do |element|
      element.children.each do |child|
        if embeds.include?(child)
          embeds.delete(child)
        end
      end
    end

    elements = [
      *parent_elements,
      parent,
      *next_elements
    ]

    elements.map(&:to_s).join("\n")
  }.compact
  erb :preview
end
