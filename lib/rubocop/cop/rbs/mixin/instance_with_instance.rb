# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Style/InstanceWithInstance` and `RBSInline/Style/InstanceWithInstance`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module InstanceWithInstance
          MSG = 'Use `self` instead of `instance`.'

          #: (::RBS::AST::Declarations::Class | ::RBS::AST::Ruby::Declarations::ClassDecl decl) -> void
          def check_class(decl)
            # The meaning of `self` and `instance` changes in generic class.
            return unless decl.type_params.empty?

            decl.members.each do |member|
              case member
              when ::RBS::AST::Members::MethodDefinition, ::RBS::AST::Ruby::Members::DefMember
                next unless member.kind == :instance

                member.overloads.each do |overload|
                  overload.method_type.each_type do |type|
                    check_type(type)
                  end
                end
              when ::RBS::AST::Members::InstanceVariable, ::RBS::AST::Ruby::Members::InstanceVariableMember
                check_type(member.type)
              end
            end
          end

          #: (::RBS::Types::t type) -> void
          def check_type(type)
            case type
            when ::RBS::Types::Bases::Instance
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
