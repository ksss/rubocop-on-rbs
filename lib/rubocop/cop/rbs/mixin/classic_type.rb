# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Style/ClassicType` and `RBSInline/Style/ClassicType`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module ClassicType
          Types = ::RBS::Types #: module-alias

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

          #: (::RBS::Types::t type) -> untyped
          def check_type(type)
            find_replacement(type) do |t, replaced|
              location = t.location or next

              range = location_to_range(location)
              add_offense(range, message: "Use `#{replaced}` instead of `#{t}`") do |corrector|
                corrector.replace(range, replaced)
              end
            end
          end

          #: (::RBS::Types::t type) ?{ ([::RBS::Types::t, String]) -> untyped } -> untyped
          def find_replacement(type, &block)
            case type
            when Types::Record,
                 Types::Tuple,
                 Types::Union,
                 Types::Intersection,
                 Types::Optional,
                 Types::Proc,
                 Types::Alias,
                 Types::Interface
              type.each_type do |t|
                find_replacement(t, &block)
              end
            when Types::ClassInstance
              case type.name.to_s
              when 'TrueClass', '::TrueClass'
                block&.call([type, 'true'])
              when 'FalseClass', '::FalseClass'
                block&.call([type, 'false'])
              when 'NilClass', '::NilClass'
                block&.call([type, 'nil'])
              end
              type.each_type do |arg|
                find_replacement(arg, &block)
              end
            end
          end
        end
      end
    end
  end
end
