# Content Block Preview Prototype

A quick prototype of how we might show "snippets" of where content blocks are used on a page

This uses [Nokogiri](https://nokogiri.org/) to parse some HTML documents with content blocks.

The [`SnippetBuilder`](./lib/snippet_builder.rb) class cycles through each embed block, fetching the
previous two and next two HTML elements and nesting the content block's parent object in between, then
rendering the HTML. If multiple content blocks are contained in a snippet, any duplicate snippets are
then discarded.

## Setup

Install the dependencies:

```bash
bundle install
```

Run the application

```bash
bundle exec ruby app.rb
```
