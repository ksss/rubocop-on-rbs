# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # @example default
        #   # bad
        #   def foo: () -> String | () -> (Integer)
        #
        #   # good
        #   def foo: () -> String
        #          | () -> Integer
        class OverloadIndentation < Base
          MSG = 'Indent the `|` to the first `:`'
          extend AutoCorrector

          def on_rbs_def(decl)
            # class Foo
            #   def foo: () -> void # Comment1
            # ^ line_start_pos
            # ^^ indent_length
            #          ^ colon_index
            #        | () -> void   # Comment2
            #        ^ Indent
            # end
            return unless 1 < decl.overloads.size

            line_start_pos = processed_source.raw_source.rindex(/\R/, decl.location.start_pos) + 1
            indent_length = decl.location.start_pos - line_start_pos
            colon_index = indent_length + decl.location.source.index(':')
            enum = decl.overloads.each
            enum.next # first overload
            while (overload = enum.next)
              overload_start_pos = overload.method_type.location.start_pos
              overload_line_start_pos = processed_source.raw_source.rindex(/\R/, overload_start_pos) + 1
              # ignore if same line
              next if overload_line_start_pos == line_start_pos

              pipeline_pos = processed_source.raw_source.rindex('|', overload_start_pos)
              next unless pipeline_pos

              overload_indent_length = pipeline_pos - overload_line_start_pos
              if overload_indent_length != colon_index
                range = range_between(overload_line_start_pos, pipeline_pos)
                add_offense(range) do |corrector|
                  corrector.replace(range, ' ' * colon_index)
                end
              end
            end
          rescue StopIteration
            # end of enum
          end
        end
      end
    end
  end
end
