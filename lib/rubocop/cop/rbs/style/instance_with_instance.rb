# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # Checks that `instance` in instance context.
        #
        # @example (default)
        #   # bad
        #   def foo: (instance) -> instance
        #
        #   # good
        #   def foo: (self) -> self
        #
        class InstanceWithInstance < RuboCop::RBS::CopBase
          extend AutoCorrector
          MSG = 'Use `self` instead of `instance`.'

          def on_rbs_def(decl)
            return unless decl.kind == :instance

            decl.overloads.each do |overload|
              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          def on_rbs_var(decl)
            case decl
            when ::RBS::AST::Members::InstanceVariable
              check_type(decl.type)
            end
          end

          def check_type(type)
            case type
            when ::RBS::Types::Bases::Instance
              return unless type.location

              range = location_to_range(type.location)
              add_offense(range) do |corrector|
                corrector.replace(range, 'self')
              end
            end
          end
        end
      end
    end
  end
end
