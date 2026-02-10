# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks empty lines around overloads.
        #
        # @example
        #   # bad
        #   def foo: () -> void
        #
        #          | (Integer) -> Integer
        #
        #   # good
        #   def foo: () -> void
        #          | (Integer) -> Integer
        #
        class EmptyLinesAroundOverloads < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Empty line detected around overloads.'

          # @rbs decl: ::RBS::AST::Members::MethodDefinition
          # @rbs return: void
          def on_rbs_def(decl)
            if decl.overloading?
              return unless 0 < decl.overloads.length

              # : () -> void
              #
              #   | ...
              end_location = decl.overloads.last.method_type.location or return
              slice = processed_source.raw_source[end_location.end_pos..] or return
              bar_index = slice.index('|') or return
              bar_line = slice[0..bar_index]&.count("\n") or return
              check_empty_lines(end_location.end_line, end_location.end_line + bar_line)
            else
              return unless 1 < decl.overloads.length

              decl.overloads.each_cons(2) do |overload, next_overload|
                overload or next
                next_overload or next
                check_empty_lines(overload.method_type.location&.end_line || 0, next_overload.method_type.location&.start_line || 0)
              end
            end
          end

          # @rbs end_line: Integer
          # @rbs next_start_line: Integer
          # @rbs return: void
          def check_empty_lines(end_line, next_start_line)
            return if end_line + 1 == next_start_line

            total = 0
            range = end_line...(next_start_line - 1)
            processed_source.raw_source.each_line.each_with_index do |line, lineno|
              if range.cover?(lineno) && line == "\n"
                empty_line = range_between(total, total + 1)
                add_offense(empty_line) do |corrector|
                  corrector.remove(empty_line)
                end
              end
              total += line.length
            end
          end
        end
      end
    end
  end
end
