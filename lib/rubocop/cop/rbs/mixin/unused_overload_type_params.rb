# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Lint/UnusedOverloadTypeParams` and `RBSInline/Lint/UnusedOverloadTypeParams`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module UnusedOverloadTypeParams
          MSG = 'Unused overload type variable - `%<variable>s`.'

          #: (::RBS::AST::Members::MethodDefinition | ::RBS::AST::Ruby::Members::DefMember decl) -> void
          def check_def(decl)
            decl.overloads.each do |overload|
              next if overload.method_type.type_params.empty?

              type_params = overload.method_type.type_params.dup
              map = type_params.to_h { |param| [param.name, param] }
              type_params.each do |type_param|
                if type_param.upper_bound
                  used_variable_in_type(type_param.upper_bound) do |var|
                    map.delete(var.name)
                  end
                end
              end
              overload.method_type.each_type do |type|
                used_variable_in_type(type) do |var|
                  map.delete(var.name)
                end
              end
              next if map.empty?

              map.each do |name, type_param|
                next unless type_param.location

                t = location_to_range(type_param.location[:name])
                add_offense(t, message: format(MSG, variable: name))
              end
            end
          end

          #: (::RBS::Types::t type) { (::RBS::Types::Variable) -> void } -> void
          def used_variable_in_type(type, &block)
            case type
            when ::RBS::Types::Variable
              yield type
            else
              type.each_type do |t|
                used_variable_in_type(t, &block)
              end
            end
          end
        end
      end
    end
  end
end
