# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # @example default
        #   # bad
        #   class Foo
        #     def foo: () -> void
        #     end
        #
        #   # good
        #   class Foo
        #     def foo: () -> void
        #   end
        class EmptyLinesAroundOverloads < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Empty line detected around overloads.'

          def on_rbs_def(decl)
            return unless 1 < decl.overloads.length

            decl.overloads.each_cons(2) do |overload, next_overload|
              check_empty_lines(overload, next_overload)
            end
          end

          def check_empty_lines(overload, next_overload)
            return if overload.method_type.location.end_line + 1 == next_overload.method_type.location.start_line

            source_lines = processed_source.raw_source.each_line.to_a
            total = 0
            line_indexes = [0] + source_lines.map.with_index do |_, index|
              total += source_lines[index].length
            end
            empty_range = overload.method_type.location.end_line...(next_overload.method_type.location.start_line - 1)
            line_indexes[empty_range]&.each do |line_index|
              empty_line = range_between(line_index, line_index + 1)
              add_offense(empty_line) do |corrector|
                corrector.remove(empty_line)
              end
            end
          end
        end
      end
    end
  end
end
