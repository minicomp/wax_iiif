# wax_iiif
[![Gem Version](https://badge.fury.io/rb/wax_iiif.svg)](https://badge.fury.io/rb/wax_iiif)
[![ci:test](https://github.com/minicomp/wax_iiif/actions/workflows/ci.yml/badge.svg)](https://github.com/minicomp/wax_iiif/actions/workflows/ci.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/a7d79a1b819cef81eb11/maintainability)](https://codeclimate.com/github/minicomp/wax_iiif/maintainability)

![License](https://img.shields.io/badge/license-MIT-green.svg) [![docs](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](https://www.rubydoc.info/github/minicomp/wax_iiif/)  

This fork is *mostly* a copy of the [iiif_s3 gem](https://github.com/cmoa/iiif_s3) with all the s3 dependencies and functionality removed. It creates level 0 IIIF derivatives for static exhibition sites with [Minicomp/Wax](https://github.com/minicomp/wax/) via [Wax_Tasks](https://github.com/minicomp/wax_tasks/).

## Prerequisites

This gem assumes that you have LibVips installed. If you need to install it, follow the instructions here: https://libvips.github.io/libvips/install.html.

> **Note!** The LibVips dependency is new as of `v0.3.0`! Versions `<0.3.0` use ImageMagick and Ghostscript instead.

## Installation


Add this line to your application's Gemfile:

    gem 'wax_iiif'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wax_iiif

## Usage

Documentation for using `wax_iiif` without `wax_tasks` is forthcoming. In the meantime, check out [rubydoc](https://www.rubydoc.info/gems/wax_iiif).


## Contributing

1. Fork it ( https://github.com/minicomp/wax_iiif/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
