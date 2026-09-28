# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Lint/LiteralIntersection` and `RBSInline/Lint/LiteralIntersection`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module LiteralIntersection
          MSG = "Don't use literals with `&`."

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
            on_type([::RBS::Types::Intersection], type) do |intersection|
              check_intersection(intersection)
            end
          end

          #: (::RBS::Types::Intersection intersection) -> void
          def check_intersection(intersection)
            intersection.types.each do |type|
              check_intersection_child(type)
            end
          end

          #: (::RBS::Types::t type) -> void
          def check_intersection_child(type)
            case type
            when ::RBS::Types::Literal
              range = location_to_range(type.location)
              add_offense(range)
            when ::RBS::Types::Intersection
              check_intersection(type)
            end
          end
        end
      end
    end
  end
end
