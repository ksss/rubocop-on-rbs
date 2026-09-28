# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Lint/DuplicateOverload` and `RBSInline/Lint/DuplicateOverload`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module DuplicateOverload
          MSG = 'Duplicate overload arguments detected.'

          #: (::RBS::AST::Members::MethodDefinition | ::RBS::AST::Ruby::Members::DefMember decl) -> void
          def check_def(decl)
            overloads = decl.overloads
            overloads.each_with_index do |overload, idx|
              next if idx == overloads.size - 1

              next_overloads = overloads[(idx + 1)..-1] or next
              next_overloads.each do |next_overload|
                a = method_type_with_untyped_return_type(overload.method_type)
                b = method_type_with_untyped_return_type(next_overload.method_type)
                next unless a == b

                location = next_overload.method_type.location or next
                range = location_to_range(location)
                add_offense(range)
              end
            end
          end

          private

          #: (::RBS::MethodType method_type) -> ::RBS::MethodType
          def method_type_with_untyped_return_type(method_type)
            type = method_type.type.with_return_type(::RBS::Types::Bases::Any.new(location: nil))
            method_type.update(type:)
          end
        end
      end
    end
  end
end
