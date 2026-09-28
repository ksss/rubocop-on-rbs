# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Style/EmptyArgument` and `RBSInline/Style/EmptyArgument`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module EmptyArgument
          class MethodTypeChecker
            include RuboCop::RBS::OnTypeHelper

            def initialize(base_type: nil, &block)
              @base_type = base_type
              @base = base_type.location.start_pos
              @tokens = tokenize(base_type.location.source)
              @block = block
            end

            def check
              check_method_argument
              if @base_type.block
                check_block_argument
              end
              @base_type.each_type do |type|
                check_type(type)
              end
            end

            # [T] () -> void
            def check_method_argument
              if @base_type.type_params.empty?
                will_lparen_token = @tokens[0]
              else
                rbracket_index = @tokens.index do |token|
                  token.location.start_pos + @base >= @base_type.type_params.last.location.end_pos
                end or raise
                raise unless @tokens[rbracket_index].type == :pRBRACKET

                will_lparen_token = @tokens[rbracket_index + 1]
              end

              if will_lparen_token.type != :pLPAREN
                @block.call(
                  @base + will_lparen_token.location.start_pos,
                  @base + will_lparen_token.location.start_pos + 1
                )
              end
            end

            # { () [self: instance] -> void } -> void
            def check_block_argument
              return unless @base_type.block
              return unless @base_type.block.type.each_param.first.nil?

              if @base_type.block.self_type
                self_type_index = bsearch_token_index(@base_type.block.self_type.location.start_pos)
                # ) [self:
                # ^ ^^   ^ => pRPAREN, pLBRACKET, kSELF, pCOLON
                rparen = @tokens[self_type_index - 4]
                after_rparen = @tokens[self_type_index - 3]
              else
                block_arrow_index = @tokens.find_index { |t| t.type == :pARROW } or raise
                rparen = @tokens[block_arrow_index - 1]
                after_rparen = @tokens[block_arrow_index]
              end

              if rparen.type != :pRPAREN
                @block.call(
                  @base + after_rparen.location.start_pos,
                  @base + after_rparen.location.start_pos + 1
                )
              end
            end

            def check_type(type = @base_type)
              on_type([::RBS::Types::Proc], type) do |proc_type|
                check_proc(proc_type)
              end
            end

            def check_proc(type)
              proc_start_index = bsearch_token_index(type.location.start_pos)
              proc_end_index = bsearch_token_index(type.location.end_pos)
              if @tokens[proc_start_index + 1].type != :pLPAREN
                @block.call(
                  @base + @tokens[proc_start_index + 1].location.start_pos,
                  @base + @tokens[proc_start_index + 1].location.start_pos + 1
                )
              end

              if type.block
                if type.block&.self_type
                  self_type_index = bsearch_token_index(type.block.self_type.location.start_pos)
                  # ) [self:
                  # ^ ^^   ^ => pRPAREN, pLBRACKET, kSELF, pCOLON
                  rparen = @tokens[self_type_index - 4]
                  after_rparen = @tokens[self_type_index - 3]
                else
                  block_arrow_index = @tokens[proc_start_index...proc_end_index].find_index { |t|
                    t.type == :pARROW
                  } or raise
                  block_arrow_index += proc_start_index
                  rparen = @tokens[block_arrow_index - 1]
                  after_rparen = @tokens[block_arrow_index]
                end

                if rparen.type != :pRPAREN
                  @block.call(
                    @base + after_rparen.location.start_pos,
                    @base + after_rparen.location.start_pos + 1
                  )
                end
              end
            end

            private

            def bsearch_token_index(pos)
              @tokens.bsearch_index do |token|
                token.location.start_pos + @base >= pos
              end or raise
            end

            def tokenize(source)
              ::RBS::Parser.lex(source).value.reject { |t| t.type == :tTRIVIA }
            end
          end

          MSG = 'Insert `()` when empty argument'

          #: (::RBS::AST::Members::MethodDefinition | ::RBS::AST::Ruby::Members::DefMember decl) -> void
          def check_def(decl)
            decl.overloads.each do |overload|
              method_type = overload.method_type
              if method_type.location
                MethodTypeChecker.new(base_type: method_type) { |s, e| report(s, e) }.check
              else
                # Doc-style inline annotations (`# @rbs x: ^ -> void`) have no method type location.
                method_type.each_type do |type|
                  MethodTypeChecker.new(base_type: type) { |s, e| report(s, e) }.check_type if type.location
                end
              end
            end
          end

          #: (untyped member) -> void
          def check_member(member)
            type = member.type
            return unless type&.location

            MethodTypeChecker.new(base_type: type) { |s, e| report(s, e) }.check_type
          end

          #: (Integer start_pos, Integer end_pos) -> void
          def report(start_pos, end_pos)
            range = range_between(start_pos, end_pos)
            add_offense(range) do |corrector|
              corrector.insert_before(range, '() ')
            end
          end
        end
      end
    end
  end
end
