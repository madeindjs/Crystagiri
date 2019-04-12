# Crystagiri

An HTML parser library for Crystal like the amazing [Nokogiri](https://github.com/sparklemotion/nokogiri) Ruby gem.

> I won't pretend that **Crystagiri** does much as **Nokogiri**. All help is welcome! :)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  crystagiri:
    github: madeindjs/crystagiri
```

and then run

```bash
$ crystal deps
```

## Usage

```crystal
require "crystagiri"
```

Then you can simply instantiate  a `Crystagiri::HTML` object from an HTML `String` like this

```crystal
doc = Crystagiri::HTML.new "<h1>Crystagiri is awesome!!</h1>"
```

... or directly load it from a Web URL or a pathname:

```crystal
doc = Crystagiri::HTML.from_file "README.md"
doc = Crystagiri::HTML.from_url "http://example.com/"
```

> Also you can specify `follow: true` flag if you want to follow redirect URL

Then you can search all [`XML::Node`](https://crystal-lang.org/api/XML/Node.html)s from the `Crystagiri::HTML` instance. The tags found will be `Crystagiri::Tag` objects with the `.node` property:

* CSS query

```Crystal
puts doc.css("li > strong.title") { |tag| puts tag.node}
# => <strong class="title"> .. </strong>
# => <strong class="title"> .. </strong>
```

> **Known limitations**: Currently, you can't use CSS queries with complex search specifiers like `:nth-child`

* HTML tag

```Crystal
doc.where_tag("h2") { |tag| puts tag.content }
# => Development
# => Contributing
```

* HTML id

```Crystal
puts doc.at_id("main-content").tagname
# => div
```

* HTML class attribute

```Crystal
doc.where_class("summary") { |tag| puts tag.node }
# => <div class="summary"> .. </div>
# => <div class="summary"> .. </div>
# => <div class="summary"> .. </div>
```

## Benchmark

I know you love benchmarks between **Ruby** & **Crystal**, so here's one:

```ruby
require "nokogiri"
t1 = Time.now
doc = Nokogiri::HTML File.read("spec/fixture/HTML.html")
1..100000.times do
  doc.at_css("h1")
  doc.css(".step-title"){ |tag| tag }
end
puts "executed in #{Time.now - t1} milliseconds"
```

> executed in 00:00:24.4 seconds with Ruby 2.6.0 with RVM on old Mac

```crystal
require "crystagiri"
t = Time.now
doc = Crystagiri::HTML.from_file "./spec/fixture/HTML.html"
1..100000.times do
  doc.at_css("h1")
  doc.css(".step-title") { |tag| tag }
end
puts "executed in #{Time.now - t} milliseconds"
```

> executed in 00:00:05.69 seconds on Crystal 0.27.2 on LLVM 6.0.1 with release flag on the same old mac

Crystagiri is **four time faster** than Nokogiri!!


## Development

Clone this repository and navigate to it:

```bash
$ git clone https://github.com/madeindjs/crystagiri.git
$ cd crystagiri
```

You can generate all documentation with

```bash
$ crystal doc
```

And run **spec** tests to ensure everything works correctly

```bash
$ crystal spec
```


## Contributing

1. Fork it ( https://github.com/madeindjs/crystagiri/fork )
2. Create your feature branch `git checkout -b my-new-feature`
3. Commit your changes `git commit -am "Add some feature"`
4. Push to the branch `git push origin my-new-feature`
5. Create a new Pull Request

## Contributors

See the [list on Github](https://github.com/madeindjs/Crystagiri/graphs/contributors)
