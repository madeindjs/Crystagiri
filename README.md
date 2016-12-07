# Crystagiri

An Html parser library for Crystal like amazing [Nokogiri](https://github.com/sparklemotion/nokogiri) Ruby gem.

> I not pretend that **Crystagiri** does much as **Nokogiri**. All help will be welcome! :)

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

Then you can simply instanciate  a `Crystagiri::HTML` from a Html `String` like this

```crystal
doc = Crystagiri::HTML.new "<h1>Crystagiri is awesome!!</h1>"
```

... or directly load it from a Web Url or a pathname:

```crystal
doc = Crystagiri::HTML.from_file "README.md"
doc = Crystagiri::HTML.from_url "http://example.com/"
```

Then you can search all [`XML::Node`](https://crystal-lang.org/api/0.20.1/XML/Node.html) by:

* CSS query

```Crystal
puts doc.at_css("a.method-permalink")
# => <a class="method-permalink"> .. </a>

puts doc.css("li > strong.title") { |node| puts node}
# => <strong class="title"> .. </strong>
# => <strong class="title"> .. </strong>
```


* HTML tag

```Crystal
doc.where_tag("h2") { |node| puts node }
# => <h2> .. </h2>
# => <h2> .. </h2>
# => <h2> .. </h2>
```

* HTML id

```Crystal
puts doc.at_id("main-content") 
# => <div id="main-content"> ... </div>
```

* HTML class attribute

```Crystal
doc.where_class("summary") { |node| puts node }
# => <div class="summary"> .. </div>
# => <div class="summary"> .. </div>
# => <div class="summary"> .. </div>
```


> **Know limitations**: For the moment you can't use css query with complex search like `:nth-child`

## Development

Clone this repository and go in it:

```bash
$ git clone https://github.com/madeindjs/crystagiri.git
$ cd crystagiri
```

You can generate the complete documentation with 

```bash
$ crystal doc
```

And run **spec** tests to ensure all work correctly 

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

- [madeindjs](https://github.com/madeindjs) - creator, maintainer
