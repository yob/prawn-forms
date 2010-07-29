# encoding: utf-8
#
# forms.rb : Interactive form support for prawn
#
# Copyright August 2009, James Healy. All Rights Reserved.
#
# This is free software. Please see the LICENSE file for details.

module Prawn
  module Forms

    def button(text)
      add_interactive_field(:Btn, :T => Prawn::Core::LiteralString.new(text),
                                  :DA => Prawn::Core::LiteralString.new("/Helv 0 Tf 0 g"),
                                  :F => 4,
                                  :Ff => 65536,
                                  :MK => {:CA => Prawn::Core::LiteralString.new(text), :BG => [0.75294, 0.75294, 0.75294], :BC => [0.75294, 0.75294, 0.75294]},
                                  :Rect => [304.5, 537.39, 429, 552.39])

    end

    def text_field(name, x, y, w, h, opts = {})
      x, y = map_to_absolute(x, y)
      field_dict = {:T => Prawn::Core::LiteralString.new(name),
                    :DA => Prawn::Core::LiteralString.new("/Helv 0 Tf 0 g"),
                    :F => 4,
                    :Ff => 0,
                    :BS => {:Type => :Border, :W => 1, :S => :S},
                    :MK => {:BC => [0, 0, 0]},
                    :Rect => [x, y, x + w, y + h]}

      if opts[:default]
        field_dict[:V] = Prawn::Core::LiteralString.new(opts[:default])
      end

      add_interactive_field(:Tx, field_dict)
    end

    private

    def add_interactive_field(type, opts = {})
      defaults = {:FT => type, :Type => :Annot, :Subtype => :Widget}
      annotation = ref!(opts.merge(defaults))
      acroform.data[:Fields] << annotation
      state.page.dictionary.data[:Annots] ||= []
      state.page.dictionary.data[:Annots] << annotation
    end

    # The AcroForm dictionary (PDF spec 8.6) for this document. It is
    # lazily initialized, so that documents that do not use interactive
    # forms do not incur the additional overhead.
    def acroform
      state.store.root.data[:AcroForm] ||= 
        ref!({:DR => acroform_resources, 
              :DA => Prawn::Core::LiteralString.new("/Helv 0 Tf 0 g"),
              :Fields => []})
    end

    # a resource dictionary for interactive forms. At a minimum,
    # must contain the font we want to use
    def acroform_resources
      helv = ref!(:Type     => :Font,
                  :Subtype  => :Type1,
                  :BaseFont => :Helvetica,
                  :Encoding => :WinAnsiEncoding)
      ref!(:Font => {:Helv => helv})
    end
  end
end

require 'prawn/document'
Prawn::Document.send(:include, Prawn::Forms)
