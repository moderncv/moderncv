# moderncv

[![Build template](https://github.com/moderncv/moderncv/actions/workflows/build-pdf.yml/badge.svg)](https://github.com/moderncv/moderncv/actions/workflows/build-pdf.yml)
[![CTAN](https://img.shields.io/ctan/v/moderncv.svg)](https://www.ctan.org/pkg/moderncv)
[![Matrix](https://img.shields.io/matrix/moderncv:matrix.org)](https://matrix.to/#/#moderncv:matrix.org)

## A modern curriculum vitae class for LaTeX

The `moderncv` package provides a document class for typesetting applications (curricula vitae and cover letters) in various styles. `moderncv` aims to be both straightforward to use and customizable, providing five ready-made styles (classic, casual, banking, oldstyle and fancy) and allowing you to define your own by modifying colors, fonts, icons, etc.

## Getting started

### Installation
`moderncv` should already be included in your installed LaTeX distribution.
If not, you can get the tarball of the package from [CTAN](https://www.ctan.org/pkg/moderncv).
Alternatively, you can also build the package from source by cloning the its [GitHub repository](https://github.com/moderncv/moderncv) and compiling the included LaTeX files:
```
latexmk -pdf ./template.tex manual/moderncv_userguide.tex
```

### Usage
To get started on your own CV, use and modify the template file `template.tex`.
The user guide can be found in the folder `manual` and contains additional information on what the document class offers.
Take a look at it to see if this package suits your needs.

If you are using the [`academicons`](https://ctan.org/tex-archive/fonts/academicons) package in the template, you will need to use a Xe(La)TeX or Lua(La)TeX engine to render the icons. Otherwise, an alternative icon package will be used automatically.

## Development

As the main goal is to keep this package alive, it is maintained in a loosely structured team.
You can contact us in our matrix room [moderncv:matrix.org](https://matrix.to/#/#moderncv:matrix.org), feel free to join if you have questions or want to contribute.
Development takes place at [github.com/moderncv/moderncv](https://github.com/moderncv/moderncv).

## Licence

`moderncv` is licensed under the [LPPL-1.3c](https://spdx.org/licenses/LPPL-1.3c.html).

## Origin

Original author: Xavier Danaux <xdanaux@gmail.com>
<br/>
Original repository: https://github.com/xdanaux/moderncv

This repository is a fork aiming to maintain `moderncv` inside CTAN, since upstream has been dead since 2016.
