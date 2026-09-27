# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Style/ClassWithSingleton` and `RBSInline/Style/ClassWithSingleton`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module ClassWithSingleton
          MSG = 'Use `self` instead of `class`.'

          #: (::RBS::AST::Members::MethodDefinition | ::RBS::AST::Ruby::Members::DefMember decl) -> void
          def check_def(decl)
            return unless decl.kind == :singleton

            decl.overloads.each do |overload|
              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          #: (::RBS::Types::t type) -> void
          def check_type(type)
            case type
            when ::RBS::Types::Bases::Class
              return unless type.location

              range = location_to_range(type.location)
              add_offense(range) do |corrector|
                corrector.replace(range, 'self')
              end
            else
              type.each_type do |t|
                check_type(t)
              end
            end
          end
        end
      end
    end
  end
end
