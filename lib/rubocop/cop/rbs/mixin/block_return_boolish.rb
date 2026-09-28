# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Style/BlockReturnBoolish` and `RBSInline/Style/BlockReturnBoolish`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module BlockReturnBoolish
          MSG = 'Use `boolish` instead of `bool` in block return type.'

          #: (::RBS::AST::Members::MethodDefinition | ::RBS::AST::Ruby::Members::DefMember decl) -> void
          def check_def(decl)
            decl.overloads.each do |overload|
              next unless overload.method_type.block

              return_type = overload.method_type.block.type.return_type
              next unless return_type.is_a?(::RBS::Types::Bases::Bool)
              next unless return_type.location

              range = location_to_range(return_type.location)
              add_offense(range) do |corrector|
                corrector.replace(range, 'boolish')
              end
            end
          end
        end
      end
    end
  end
end
