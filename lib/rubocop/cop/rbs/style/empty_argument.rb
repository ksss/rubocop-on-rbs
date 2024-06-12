# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # @example default
        #   # bad
        #   def foo: -> void
        #
        #   # bad
        #   def foo: () { -> void } -> void
        #
        #   # bad
        #   def foo: () -> ^ -> void
        #
        #   # good
        #   def foo: () { () -> void } -> ^() -> void
        class EmptyArgument < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = 'Insert `()` when empty argument'

          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              if !overload.method_type.location.source.start_with?('(')
                range = range_between(overload.method_type.location.start_pos, overload.method_type.location.start_pos)
                add_offense(range) do |corrector|
                  corrector.insert_before(range, '()')
                end
              end
              if overload.method_type.block
                tokens = tokenize(overload.method_type.location.source)
                block_arrow_index = tokens.find_index { |t| t.type == :pARROW } or binding.irb
                if tokens[block_arrow_index - 1].type != :pRPAREN
                  range = range_between(
                    overload.method_type.location.start_pos + tokens[block_arrow_index].location.start_pos,
                    overload.method_type.location.start_pos + tokens[block_arrow_index].location.start_pos
                  )
                  add_offense(range) do |corrector|
                    corrector.insert_before(range, '()')
                  end
                end
              end

              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          def check_type(type)
            case type
            when ::RBS::Types::Proc
              check_proc(type)
            else
              type.each_type do |t|
                check_type(t)
              end
            end
          end

          def check_proc(type)
            tokens = tokenize(type.location.source)
            if tokens[1].type != :pLPAREN
              range = range_between(
                type.location.start_pos + tokens[0].location.end_pos,
                type.location.start_pos + tokens[0].location.end_pos
              )
              add_offense(range) do |corrector|
                corrector.insert_after(range, '()')
              end
            end

            if type.block
              block_arrow_index = tokens.find_index { |t| t.type == :pARROW } or raise
              if tokens[block_arrow_index - 1].type != :pRPAREN
                range = range_between(
                  type.location.start_pos + tokens[block_arrow_index].location.start_pos,
                  type.location.start_pos + tokens[block_arrow_index].location.start_pos
                )
                add_offense(range) do |corrector|
                  corrector.insert_before(range, '()')
                end
              end
            end
          end

          def tokenize(source)
            ::RBS::Parser.lex(source).value.reject { |t| t.type == :tTRIVIA }
          end
        end
      end
    end
  end
end