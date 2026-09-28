# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Style/OptionalNil` and `RBSInline/Style/OptionalNil`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module OptionalNil
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
            find_replacement(type) do |t, replaced|
              location = t.location or next

              range = location_to_range(location)
              add_offense(range, message: "Use `#{replaced}` instead of `#{t}`") do |corrector|
                corrector.replace(range, replaced.to_s)
              end
            end
          end

          #: (::RBS::Types::t type) ?{ ([::RBS::Types::t, ::RBS::Types::t]) -> untyped } -> untyped
          def find_replacement(type, &block)
            case type
            when ::RBS::Types::Optional
              case type.type
              when ::RBS::Types::Bases::Nil
                block&.call([type, ::RBS::Types::Bases::Nil.new(location: nil)])
              else
                find_replacement(type.type, &block)
              end
            else
              type.each_type do |type|
                find_replacement(type, &block)
              end
            end
          end
        end
      end
    end
  end
end
