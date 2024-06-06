# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Notice useless overload type parameters.
        #
        # @example default
        #   # bad
        #   def foo: [T] () -> void
        #
        #   # bad
        #   def bar: [T] () -> T
        #
        #   # bad
        #   def baz: [T] () { () -> T } -> void
        #
        #   # good
        #   def foo: [T] (Array[T]) -> T
        class RedundantOverloadTypeParams < RuboCop::RBS::CopBase
          MSG = 'Redundant overload type variable - `%<variable>s`.'

          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              next if overload.method_type.type_params.empty?

              type_params = overload.method_type.type_params

              types = []
              overload.method_type.type.each_param do |param|
                types << param.type
              end
              overload.method_type.block&.then do |block|
                block.type.each_type do |t|
                  types << t
                end
              end
              types.each do |type|
                used_variable_in_type(type) do |var|
                  type_params.delete_if { |type_param| type_param.name == var.name }
                end
              end
              next if type_params.empty?

              type_params.each do |type_param|
                next unless type_param.location

                t = location_to_range(type_param.location[:name])
                add_offense(t, message: format(MSG, variable: type_param.name), severity: :warning)
              end
            end
          end

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
