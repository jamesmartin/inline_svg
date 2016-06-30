# Inline SVG

Styling a SVG document with CSS for use on the web is most reliably achieved by
[adding classes to the document and
embedding](http://css-tricks.com/using-svg/) it inline in the HTML.

This gem is a little Rails helper method (`inline_svg`) that reads an SVG document (via Sprockets, so works with the Rails Asset Pipeline), applies a CSS class attribute to the root of the document and
then embeds it into a view.

Inline SVG supports [Rails version 4.0.4](http://weblog.rubyonrails.org/2014/3/14/Rails-4-0-4-has-been-released/) and newer.

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

```haml
= inline_svg('iconmonstr-glasses-12-icon.svg', class: 'medium-blue', title: 'An SVG', desc: 'This is my SVG. There are many like it. You get the picture', aria: true)
```

```xml
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" x="0px" y="0px" width="512px" height="512px" viewBox="0 0 512 512" style="enable-background:new 0 0 512 512;" xml:space="preserve" data-default-transform="some-default" class="medium-blue" role="img" aria-labelledby="bx6wix4t9pxpwxnohrhrmms3wexsw2o m439lk7mopdzmouktv2o689pl59wmd2"><title id="bx6wix4t9pxpwxnohrhrmms3wexsw2o">An SVG</title>
    <path id="glasses-12" d="M358.045,135.833c-19.531,0-40.788,2.213-58.256,8.433c-39.195,14.216-47.93,14.393-87.594,0  c-17.452-6.22-38.742-8.433-58.256-8.433c-33.831,0-71.584,6.639-103.939,15.071v30.704c14.535,4.384,18.34,10.763,20.654,25.624  c6.538,41.953,21.542,83.102,87.007,83.102c52.137,0,69.538-38.785,81.055-74.594c5.851-18.189,28.55-18.658,34.484-0.251  c11.551,35.858,28.868,74.845,81.106,74.845c65.48,0,80.502-41.148,87.023-83.102c2.312-14.861,6.119-21.24,20.67-25.624v-30.704  C429.611,142.472,391.875,135.833,358.045,135.833z M226.16,201.307c-8.885,37.317-23.336,71.859-68.499,71.859  c-56.664,0-68.214-32.665-73.395-85.363c-1.24-12.816,1.576-17.846,3.789-20.512c16.261-19.472,102.178-18.691,130.661-1.584  C226.864,170.603,232.161,176.018,226.16,201.307z M427.7,187.803c-5.163,52.698-16.731,85.363-73.394,85.363  c-45.131,0-59.598-34.542-68.482-71.859c-6.02-25.289-0.721-30.704,7.443-35.6c28.582-17.167,114.449-17.812,130.66,1.584  C426.158,169.957,428.975,174.986,427.7,187.803z M344.65,168.557c26.42-4.023,56.965-0.52,65.078,9.213  c1.777,2.129,4.023,6.152,3.018,16.403c-0.536,5.432-1.156,10.578-1.928,15.457C403.795,184.114,385.822,170.435,344.65,168.557z   M101.165,209.63c-0.771-4.879-1.408-10.025-1.944-15.457c-1.006-10.251,1.257-14.274,3.034-16.403  c8.131-9.732,38.675-13.236,65.096-9.213C126.177,170.435,108.206,184.114,101.165,209.63z M376.166,342.923  C356.418,392.177,272.631,380.106,256,349.26c-16.647,30.847-100.418,42.917-120.167-6.337c9.924,8.685,26.873,11.483,39.798,9.589  c38.105-5.582,35.054-41.592,61.693-41.592c7.292,0,13.897,3.034,18.675,7.963c4.777-4.929,11.366-7.963,18.658-7.963  c26.639,0,23.604,36.01,61.693,41.592C349.277,354.406,366.226,351.607,376.166,342.923z"></path>
    <desc id="m439lk7mopdzmouktv2o689pl59wmd2">This is my SVG. There are many like it. You get the picture</desc></svg>
```

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
