# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Style/DuplicatedType` and `RBSInline/Style/DuplicatedType`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module DuplicatedType
          #: (::RBS::AST::Members::MethodDefinition | ::RBS::AST::Ruby::Members::DefMember decl) -> void
          def check_def(decl)
            decl.overloads.each do |overload|
              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          #: (untyped member) -> void
          def check_member(member)
            type = member.type
            check_type(type) if type&.location
          end

          #: (::RBS::Types::t type) -> void
          def check_type(type)
            case type
            when ::RBS::Types::Record,
                 ::RBS::Types::Tuple,
                 ::RBS::Types::Optional,
                 ::RBS::Types::ClassInstance,
                 ::RBS::Types::Proc
              type.each_type do |t|
                check_type(t)
              end
            when ::RBS::Types::Union,
                 ::RBS::Types::Intersection
              set = Set.new
              type.types.each do |t|
                if set.include?(t)
                  if t.location
                    range = location_to_range(t.location)
                    add_offense(range, message: "Duplicated type `#{t}`.")
                  end
                else
                  set.add(t)
                end
              end
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
