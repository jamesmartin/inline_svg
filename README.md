# Inline SVG

Styling a SVG document with CSS for use on the web is most reliably achieved by
[adding classes to the document and
embedding](http://css-tricks.com/using-svg/) it inline in the HTML.

This gem is a little Rails helper method (`inline_svg`) that reads an SVG document (via Sprockets, so works with the Rails Asset Pipeline), applies a CSS class attribute to the root of the document and
then embeds it into a view.

Inline SVG (from [v0.10.0](https://github.com/jamesmartin/inline_svg/releases/tag/v0.10.0)) supports both [Rails 4](http://weblog.rubyonrails.org/2013/6/25/Rails-4-0-final/) and [Rails 5](http://weblog.rubyonrails.org/2016/6/30/Rails-5-0-final/).

Want to embed SVGs with Javascript? You might like [RemoteSvg](https://github.com/jamesmartin/remote-svg), which features similar transforms but can also load SVGs from remote URLs (like S3 etc.).

## Changelog

This project adheres to [Semantic Versioning](http://sermver.org). All notable changes are documented in the
[CHANGELOG](https://github.com/jamesmartin/inline_svg/blob/master/CHANGELOG.md).

## Installation

Add this line to your application's Gemfile:

    gem 'inline_svg'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install inline_svg

## Usage

```
inline_svg(file_name, options={})
```

The `file_name` can be a full path to a file, the file's basename or an `IO`
object. The
actual path of the file on disk is resolved using
[Sprockets](://github.com/sstephenson/sprockets) (when available), a naive file finder (`/public/assets/...`) or in the case of `IO` objects the SVG data is read from the object.
This means you can pre-process and fingerprint your SVG files like other Rails assets, or choose to find SVG data yourself.

Here's an example of embedding an SVG document and applying a 'class' attribute in
HAML:

```haml
 !!! 5 
  %html
    %head
      %title Embedded SVG Documents
    %body
      %h1 Embedded SVG Documents
      %div
        = inline_svg "some-document.svg", class: 'some-class'
```

Here's some CSS to target the SVG, resize it and turn it an attractive shade of
blue:

```css
.some-class {
  display: block;
  margin: 0 auto;
  fill: #3498db;
  width: 5em;
  height: 5em;
}
```

## Options 

key                     | description
:---------------------- | :---------- 
`id`                    | set a ID attribute on the SVG
`class`                 | set a CSS class attribute on the SVG
`data`                  | add data attributes to the SVG (supply as a hash)
`size`                  | set width and height attributes on the SVG <br/> Can also be set using `height` and/or `width` attributes, which take precedence over `size` <br/> Supplied as "{Width} * {Height}" or "{Number}", so "30px*45px" becomes `width="30px"` and `height="45px"`, and "50%" becomes `width="50%"` and `height="50%"`
`title`                 | add a \<title\> node inside the top level of the SVG document
`desc`                  | add a \<desc\> node inside the top level of the SVG document
`nocomment`             | remove comment tags (and other unsafe/unknown tags) from svg (uses the [Loofah](https://github.com/flavorjones/loofah) gem)
`preserve_aspect_ratio` | adds a `preserveAspectRatio` attribute to the SVG
`aria`                  | adds common accessibility attributes to the SVG (see [PR #34](https://github.com/jamesmartin/inline_svg/pull/34#issue-152062674) for details)

Example:

```ruby
inline_svg("some-document.svg", id: 'some-id', class: 'some-class', data: {some: "value"}, size: '30% * 20%', title: 'Some Title', desc:
'Some description', nocomment: true, preserve_aspect_ratio: 'xMaxYMax meet', aria: true)
```

## Accessibility

Use the `aria: true` option to make `inline_svg` add the following
accessibility (a11y) attributes to your embedded SVG:

* Adds a `role="img"` attribute to the root SVG element
* Adds a `aria-labelled-by="title-id desc-id"` attribute to the root SVG
  element, if the document contains `<title>` or `<desc>` elements

Here's an example:

```erb
<%=
  inline_svg('iconmonstr-glasses-12-icon.svg',
    aria: true, title: 'An SVG',
    desc: 'This is my SVG. There are many like it. You get the picture')
%>
```

```xml
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" \
  role="img" aria-labelledby="bx6wix4t9pxpwxnohrhrmms3wexsw2o m439lk7mopdzmouktv2o689pl59wmd2">
  <title id="bx6wix4t9pxpwxnohrhrmms3wexsw2o">An SVG</title>
  <desc id="m439lk7mopdzmouktv2o689pl59wmd2">This is my SVG. There are many like it. You get the picture</desc>
</svg>
```

***Note:*** The title and desc `id` attributes generated for, and referenced by, `aria-labelled-by` are one-way digests based on the value of the title and desc elements and an optional "salt" value using the SHA1 algorithm. This reduces the chance of `inline_svg` embedding elements inside the SVG with `id` attributes that clash with other elements elsewhere on the page.

## Custom Transformations

The transformation behavior of `inline_svg` can be customized by creating custom transformation classes.

For example, inherit from `InlineSvg::CustomTransformation` and implement the `#transform` method:

```ruby
# Sets the `custom` attribute on the root SVG element to supplied value
# Remember to return a document, as this will be passed along the transformation chain

class MyCustomTransform < InlineSvg::CustomTransformation
  def transform(doc)
    doc = Nokogiri::XML::Document.parse(doc.to_html)
    svg = doc.at_css 'svg'
    svg['custom'] = value
    doc
  end
end
```

Add the custom configuration in an initializer (E.g. `./config/initializers/inline_svg.rb`):

```ruby
# Note that the named `attribute` will be used to pass a value to your custom transform
InlineSvg.configure do |config|
  config.add_custom_transformation(attribute: :my_custom_attribute, transform: MyCustomTransform)
end
```

The custom transformation can then be called like so:
```haml
%div
  = inline_svg "some-document.svg", my_custom_attribute: 'some value'
```

In this example, the following transformation would be applied to a SVG document:

```xml
<svg custom="some value">...</svg>
```

You can also provide a default_value to the custom transformation, so even if you don't pass a value it will be triggered

```ruby
# Note that the named `attribute` will be used to pass a value to your custom transform
InlineSvg.configure do |config|
  config.add_custom_transformation(attribute: :my_custom_attribute, transform: MyCustomTransform, default_value: 'default value')
end
```

The custom transformation will be triggered even if you don't pass any attribute value
```haml
%div
  = inline_svg "some-document.svg"
  = inline_svg "some-document.svg", my_custom_attribute: 'some value'
```

In this example, the following transformation would be applied to a SVG document:

```xml
<svg custom="default value">...</svg>
```

And

```xml
<svg custom="some value">...</svg>
```

Passing a `priority` option with your custom transformation allows you to
control the order that transformations are applied to the SVG document:

```ruby
InlineSvg.configure do |config|
  config.add_custom_transformation(attribute: :custom_one, transform: MyCustomTransform, priority: 1)
  config.add_custom_transformation(attribute: :custom_two, transform: MyOtherCustomTransform, priority: 2)
end
```

Transforms are applied in ascending order (lowest number first).

***Note***: Custom transformations are always applied *after* all built-in
transformations, regardless of priority.

## Contributing

1. Fork it ( [http://github.com/jamesmartin/inline_svg/fork](http://github.com/jamesmartin/inline_svg/fork) )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Please write tests for anything you change, add or fix.
There is a [basic Rails
app](http://github.com/jamesmartin/inline_svg_test_app) that demonstrates the
gem's functionality in use.
