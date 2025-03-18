class SnippetBuilder
  def initialize(html)
    @doc = Nokogiri::HTML(html)
    @previous_parents = []
  end

  def title
    doc.at_css("h1").inner_text
  end

  def instances
    embeds.count
  end

  def results
    embeds.map { |embed|
      next if embed.nil?

      parent = get_parent(embed)

      elements = [
        parent.previous_element&.previous_element,
        parent.previous_element,
        parent,
        parent.next_element,
        parent.next_element&.next_element,
      ]

      result = elements.map(&:to_s).join("\n")

      next if is_already_included?(result)

      @previous_parents << embed.parent

      result
    }.compact
  end

  private

  attr_reader :doc

  def is_already_included?(result)
    @previous_parents.any? do |prev|
      result.include?(prev.to_s)
    end
  end

  def get_parent(embed)
    parent = embed.parent

    if parent.name == "li"
      parent = parent.ancestors("ul")[0]
    end

    if parent.name == "td"
      parent = parent.ancestors("table")[0]
    end

    while parent.previous_element.nil?
      parent = parent.parent
    end

    parent
  end

  def embeds
    @embeds ||= doc.css(".content-embed")
  end
end
