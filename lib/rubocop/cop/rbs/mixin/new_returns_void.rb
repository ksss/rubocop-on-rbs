# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Lint/NewReturnsVoid` and `RBSInline/Lint/NewReturnsVoid`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module NewReturnsVoid
          MSG = "Don't use `void` in self.new method. Did you mean `instance`?"

          #: (::RBS::AST::Members::MethodDefinition | ::RBS::AST::Ruby::Members::DefMember decl) -> void
          def check_def(decl)
            return unless decl.kind == :singleton
            return unless decl.name == :new

            decl.overloads.each do |overload|
              return_type = overload.method_type.type.return_type
              case return_type
              when ::RBS::Types::Bases::Void
                next unless return_type.location

                range = location_to_range(return_type.location)
                add_offense(range)
              end
            end
          end
        end
      end
    end
  end
end
