# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Style/TrueFalse` and `RBSInline/Style/TrueFalse`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module TrueFalse
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
            when ::RBS::Types::Union
              has_true = has_false = false
              type.types.each do |t|
                case t
                when ::RBS::Types::Literal
                  has_true = true if t.literal == true
                  has_false = true if t.literal == false
                when ::RBS::Types::ClassInstance
                  case t.name.to_s
                  when 'TrueClass', '::TrueClass'
                    has_true = true
                  when 'FalseClass', '::FalseClass'
                    has_false = true
                  end
                end
              end
              if has_true && has_false
                replaced = type.types.dup
                first_index = nil
                i = -1
                replaced.delete_if do |t|
                  i += 1
                  case t
                  when ::RBS::Types::Literal
                    (t.literal == true || t.literal == false).tap do |r|
                      first_index ||= i if r
                    end
                  when ::RBS::Types::ClassInstance
                    t.name.to_s.then do |s|
                      s == 'TrueClass' || s == '::TrueClass' || s == 'FalseClass' || s == '::FalseClass'
                    end.tap do |r|
                      first_index ||= i if r
                    end
                  end
                end
                replaced.insert(first_index || 0, ::RBS::Types::Bases::Bool.new(location: nil))
                block&.call([type, ::RBS::Types::Union.new(types: replaced, location: nil)])
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
