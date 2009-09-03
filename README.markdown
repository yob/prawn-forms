# prawn-forms

## Overview

This is the beginnings of a prawn extension for adding interactive forms to
PDFs.

## Installation

    gem install prawn-forms

## Usage

Prawn-Forms depends on the core prawn library, and simply adds a few additional
methods to the standard Prawn::Document object that allow you to add form elements
to your output.

Start by requiring the prawn library, then the prawn-forms library. Build your PDF as usual,
and use methods like text_field() to add a free text input box.

    require 'prawn'
    require 'prawn/forms'

    Prawn::Document.generate "form.pdf" do |pdf|
      pdf.text_field("fname", 100, 560, 200, 16)
    end

For further examples and documentation, check out the examples/ directory of this project
and the code docs for the Prawn::Forms module.

## Technical Discussion

Interactive forms are primarily defined by section 8.6 the PDF spec. The visual
appearance of fields is controlled using widget annotations, defined in section
8.4.5.

A PDF can contain *one* form.

The form is defined by a dict linked via the AcroForm entry in the root
catalog. Amongst other entries, the form dict has a Fields entry that holds an
array of all the form fields. The array should be indirect references to a
dicts, generally one per field.

Each field dict can link to one or more widget annotations that define the visual
appearance in various states. It seems most fields have a single widget
annotation, in which case it is permitted to merge the field and annotation
dicts into a single dict. Annotation and field dicts have no common keys, so
there is no conflict.

For the fields to appear on the page, the widget annotation (or merged
field/widget dict) must appear in the page Annots entry.

## Disclaimer

This code is still very much experimental and is not recommended for use in
production systems.

## Licensing

This library is distributed under the terms of the MIT License. See the included file for
more detail.

## Further Reading

- The source: [http://github.com/yob/prawn-js/tree/master](http://github.com/yob/prawn-forms/tree/master)
- Prawn source: [http://github.com/sandal/prawn/tree/master](http://github.com/sandal/prawn/tree/master)
- Rubyforge: [http://rubyforge.org/projects/prawn](http://rubyforge.org/projects/prawn)
