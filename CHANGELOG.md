# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]
- A new option: `id` adds an id attribute to the SVG.
- A new option: `data` adds data attributes to the SVG.

## [0.4.0] - 2015-03-22
### Added
- A new option: `size` adds width and height attributes to an SVG. Thanks, @2metres.

### Changed
- Dramatically simplified the TransformPipeline and Transformations code.
- Added tests for the pipeline and new size transformations.

### Fixed
- Transformations can no longer be created with a nil value.

## [0.3.0] - 2015-03-20
### Added
- Use Sprockets to find canonical asset paths (fingerprinted, post asset-pipeline).

## [0.2.0] - 2014-12-31
### Added
- Optionally remove comments from SVG files. Thanks, @jmarceli.

## [0.1.0] - 2014-12-15
### Added
- Optionally add a title and description to a document. Thanks, ludwig.schubert@qlearning.de.
- Add integration tests for main view helper. Thanks, ludwig.schubert@qlearning.de.

## 0.0.1 - 2014-11-24
### Added
- Basic Railtie and view helper to inline SVG documents to Rails views.

[unreleased]: https://github.com/jamesmartin/inline_svg/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/jamesmartin/inline_svg/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/jamesmartin/inline_svg/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/jamesmartin/inline_svg/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/jamesmartin/inline_svg/compare/v0.0.1...v0.1.0
