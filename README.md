# Cristagiri

An Html parser library for Crystal like amazing [Nokogiri](https://github.com/sparklemotion/nokogiri) Ruby gem.

> I not pretend that **Cristagiri** does much as **Nokogiri**. All help will be welcome! :)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cristagiri:
    github: madeindjs/cristagiri
```

and then run 

```bash
$ crystal deps
```

## Usage

```crystal
require "cristagiri"
```

Then you can simply instanciate  a `Cristagiri::HTML` from a Html `String` like this

```crystal
doc = Cristagiri::HTML.new "<h1>Cristagiri is awesome!!</h1>"
```

... or directly load it from a Web Url or a pathname:

```crystal
doc = Cristagiri::HTML.from_file "README.md"
doc = Cristagiri::HTML.from_url "http://example.com/"
```

Then you can search [`XML::Node`](https://crystal-lang.org/api/0.20.1/XML/Node.html) from `Cristagiri::HTML` instance:

```crystal
# find by id
puts doc.at_id("main-content") # => <div id="main-content"> ... </div>

# Find by css query
doc.css("#main-content ol.steps") {|node| puts node}
# => <ol class="steps"> .. </ol>
doc.css("#body>quote.introduction") {|node| puts node}
# => <quote class="introduction"> .. </quote>

# find all tag by their classnames
doc.class("summary") { |node| puts node }
# => <div class="summary"> .. </div>
# => <div class="summary"> .. </div>
# => <div class="summary"> .. </div>

# find all tag by their types
doc.tag("h2") { |node| puts node }
```

> **Know limitations**: For the moment you can't use css query with complex search like `:nth-child`

## Development

Clone this repository and go in it:

```bash
$ git clone https://github.com/madeindjs/cristagiri.git
$ cd cristagiri
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

1. Fork it ( https://github.com/madeindjs/cristagiri/fork )
2. Create your feature branch `git checkout -b my-new-feature`
3. Commit your changes `git commit -am "Add some feature"`
4. Push to the branch `git push origin my-new-feature`
5. Create a new Pull Request

## Contributors

- [madeindjs](https://github.com/madeindjs) - creator, maintainer
