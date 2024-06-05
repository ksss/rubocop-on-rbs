# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # @example default
        #   # bad
        #   def initialize: () -> untyped
        #
        #   # bad
        #   def initialize: () -> nil
        #
        #   # good
        #   def initialize: () -> void
        class InitializeReturnType < RuboCop::RBS::CopBase
          extend AutoCorrector
          MSG = '`#initialize` method should return `void`'

          # @sig decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            return unless decl.name == :initialize
            return unless decl.kind == :instance
            return unless decl.overloading == false

            decl.overloads.each do |overload|
              return_type = overload.method_type.type.return_type
              next if return_type.is_a?(::RBS::Types::Bases::Void)

              range = location_to_range(return_type.location)
              add_offense(range) do |corrector|
                corrector.replace(range, 'void')
              end
            end
          end
        end
      end
    end
  end
end
