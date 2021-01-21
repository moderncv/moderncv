# moderncv

## A modern curriculum vitae class for LaTeX

`moderncv` provides a documentclass for typesetting applications (curricula vitae and cover letters) in various styles. `moderncv` aims to be both straightforward to use and customizable, providing five ready-made styles (classic, casual, banking, oldstyle and fancy) and allowing one to define his own by modifying colors, fonts, icons, etc.

### Getting started 
Once you clone this repo have a look at some examples and build the manual to see if this package suits your needs.
This can be done by issuing 
```make
make userguide
```
in a terminal. After completion of the compilation precompiled versions of the template in all styles can be found in the folder `examples` and 
the user guide in the folder `manual`.  
Alternatively get the tar ball from [CTAN](https://ctan.org/pkg/moderncv?lang=de). The examples as well as the documentation are already prebuilt in that tarball.

To start working on your own application use and modify the template file `template.tex`.
The user guide can be found in the folder `manual` and contains additional information on what the document class offers.

### Makefile
The `Makefile` supports the following rules.

#### Rules for building templates and the user guide
* `template:` Build the `moderncv` template `template.tex` with `LuaLaTeX`. This rule can be called in one of two ways: 
  * `make template`: Build the template in default style.
  * `make template STYLE=<style>`: Build the template in the style specified by
	`<style>`. `<style>` can be classic, casual, banking, oldstyle or fancy.

* `templates:` Build the template `template.tex` with LuaLaTeX for _all moderncv styles_ and move resulting `pdf` files to the folder `examples/`.

* `userguide:`  Build the user manual `manual/moderncv_userguide.tex` with `LuaLaTeX`. This rule calls the rule `templates` before compiling the documentation.

* `clean:` Clean the clutter created by compiling the documents.

* `delete:`Delete `template.pdf` and `manual/moderncv_userguide.pdf`.

* `deleteexamples:` Delete `examples/` folder and remaining template example `pdf` files in folder `manual/`.

* `force:`  Force rebuilding the user guide by running the rules `delete` `deleteexamples`  `userguide` and clean.

#### Rules intended for package maintainance
* `version:` Update the version information (version number and date) of all `moderncv` files (*.sty, moderncv.cls, *.tex). This rule can be called in two different ways. Note, however, that it is intended to be called by the rule `release` and usually does not need to be called explicitly.
  * `make version`: Called in this way the version number is obtained through `git describe --tags`. If this information is newer all `moderncv` files get updated. 
  * `make version NEW=<version number>`: Optionally, the desired version number `<version number>` can be specified. 

* `tarball:`  Create a new release tarball suitable for upload to CTAN. If the `example/` folder is present, it gets included in the tar archive. Similary, all `pdf` files in the `manual/` folder get included aswell. This rule is intended to be called by the rule `release` and usually does not need to be called explicitly.

* `release:`Update the version information of all files including the subtitle
  in the user guide, rebuild examples as well as the user
  guide and create a releasable tarball including the compiled pdfs. 
  Before runing `make release` for an actual release be sure to tag the last
  commit with the intended version information.


If using [`academicons`](https://ctan.org/tex-archive/fonts/academicons) in the template, you need to use a Xe(La)TeX or Lua(La)TeX engine for them to render. Otherwise an alternative will be used automatically.

## Development

[![Build template](https://github.com/moderncv/moderncv/actions/workflows/build-pdf.yml/badge.svg)](https://github.com/moderncv/moderncv/actions/workflows/build-pdf.yml)
[![CTAN](https://img.shields.io/ctan/v/moderncv.svg)](https://www.ctan.org/pkg/moderncv)
[![Matrix](https://img.shields.io/matrix/moderncv:matrix.org)](https://matrix.to/#/#moderncv:matrix.org)

As the main goal is to keep this package alive, it is maintained in a loosely structured team. You can contact us in our matrix room [moderncv:matrix.org](https://matrix.to/#/#moderncv:matrix.org), feel free to join if you have questions or want to contribute. Development takes place at [github.com/moderncv/moderncv](https://github.com/moderncv/moderncv).

## Licence
`moderncv` is licensed under the [LPPL-1.3c](https://spdx.org/licenses/LPPL-1.3c.html).

## Origin
Original author: Xavier Danaux <xdanaux@gmail.com><br/>
Original repository: https://github.com/xdanaux/moderncv<br/>
This repository is a fork aiming to maintain moderncv inside CTAN, since upstream is dead since 2016.
