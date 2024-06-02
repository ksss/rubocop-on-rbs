# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # @example default
        #   # bad
        #   def foo: ()->void
        #
        #   # bad
        #   def bar: () { ()->void } -> void
        #
        #   # good
        #   def foo: () -> void
        #
        #   # good
        #   def bar: () { () -> void } -> void
        class SpaceAroundArrow < Base
          extend AutoCorrector

          MSG_BEFORE = 'Use one space before `->`.'
          MSG_AFTER = 'Use one space after `->`.'

          # @sig decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              check_overload(overload)
            end
          end

          def check_overload(overload)
            check_function(overload.method_type.location, overload.method_type.type)
            if overload.method_type.block
              check_function(overload.method_type.location, overload.method_type.block.type)
            end
            overload.method_type.each_type do |type|
              case type
              when ::RBS::Types::Proc
                check_function(type.location, type.type)
                if type.block
                  check_function(type.location, type.block.type)
                end
              end
            end
          end

          def check_function(loc, fun)
            return_type_start_pos = fun.return_type.location.start_pos
            arrow_start_length = loc.source.rindex('->', return_type_start_pos - loc.start_pos)
            return unless arrow_start_length

            word_before_arrow_length = loc.source.rindex(/[^\s]/, arrow_start_length - 1)
            return unless word_before_arrow_length

            if word_before_arrow_length + 2 != arrow_start_length
              arrow = arrow_range(loc.start_pos + arrow_start_length)
              add_offense(arrow, message: MSG_BEFORE) do |corrector|
                replace = Parser::Source::Range.new(
                  processed_source.buffer,
                  loc.start_pos + word_before_arrow_length + 1,
                  loc.start_pos + arrow_start_length,
                )
                corrector.replace(replace, ' ')
              end
              return
            end

            arrow_after_word_length = loc.source.index(/[^\s]/, arrow_start_length + 2)
            return unless arrow_after_word_length

            if arrow_start_length + 3 != arrow_after_word_length
              arrow = arrow_range(loc.start_pos + arrow_start_length)
              add_offense(arrow, message: MSG_AFTER) do |corrector|
                replace = Parser::Source::Range.new(
                  processed_source.buffer,
                  loc.start_pos + arrow_start_length + 2,
                  loc.start_pos + arrow_after_word_length,
                )
                corrector.replace(replace, ' ')
              end
            end
          end

          def arrow_range(base_pos)
            Parser::Source::Range.new(
              processed_source.buffer,
              base_pos,
              base_pos + 2,
            )
          end
        end
      end
    end
  end
end
