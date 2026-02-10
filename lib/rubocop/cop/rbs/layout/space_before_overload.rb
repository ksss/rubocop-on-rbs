# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # @example default
        #   # bad
        #   def foo:() -> void
        #          |  () -> void
        #
        #   # good
        #   def foo: () -> void
        #          | () -> void
        class SpaceBeforeOverload < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Use one space before overload.'

          # @rbs decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            decl.overloads.each_with_index do |overload, i|
              loc = overload.method_type.location or next
              overload_char = i == 0 ? ':' : '|'
              check(loc, overload_char)
            end

            if decl.overloading?
              loc = decl.location or return
              overloading_loc = loc[:overloading] or return
              overload_char = decl.overloads.length == 0 ? ':' : '|'
              check(overloading_loc, overload_char)
            end
          end

          private

          # @rbs loc: ::RBS::Location[bot, bot]
          def check(loc, overload_char)
            source = processed_source.raw_source

            char_start_pos = source.rindex(overload_char, loc.start_pos)
            return unless char_start_pos

            word_after_char_pos = source.index(/[^\s]/, char_start_pos + 1)
            return unless word_after_char_pos

            if char_start_pos + 2 != word_after_char_pos
              char = range_between(char_start_pos, char_start_pos + 1)
              add_offense(char) do |corrector|
                range = range_between(char_start_pos + 1, word_after_char_pos)
                corrector.replace(range, ' ')
              end
            end
          end
        end
      end
    end
  end
end
