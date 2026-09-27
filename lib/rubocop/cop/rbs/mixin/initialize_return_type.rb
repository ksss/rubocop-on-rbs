# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Style/InitializeReturnType` and `RBSInline/Style/InitializeReturnType`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module InitializeReturnType
          MSG = '`#initialize` method should return `void`'

          #: (::RBS::AST::Members::MethodDefinition | ::RBS::AST::Ruby::Members::DefMember decl) -> void
          def check_def(decl)
            return unless decl.name == :initialize
            return unless decl.kind == :instance
            return if decl.overloading?

            decl.overloads.each do |overload|
              return_type = overload.method_type.type.return_type
              next if return_type.is_a?(::RBS::Types::Bases::Any)
              next if return_type.is_a?(::RBS::Types::Bases::Void)
              next unless return_type.location

              range = location_to_range(return_type.location)
              add_offense(range) do |corrector|
                corrector.replace(range, 'void')
              end
            end
          end
        end
      end
    end
  end
end
