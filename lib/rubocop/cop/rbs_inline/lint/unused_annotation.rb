# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Lint
        # Checks for inline annotations that are not associated with any definition.
        #
        # An annotation is unused when it is not placed right above the definition
        # it annotates, or when it names a parameter the method does not have.
        #
        # @example
        #   # bad
        #   # @rbs x: Integer
        #
        #   def foo(x)
        #   end
        #
        #   # bad
        #   # @rbs y: Integer
        #   def foo(x)
        #   end
        #
        #   # good
        #   # @rbs x: Integer
        #   def foo(x)
        #   end
        #
        class UnusedAnnotation < RuboCop::RBSInline::CopBase
          def on_inline_new_investigation
            processed_inline_source.diagnostics.each do |diagnostic|
              next unless diagnostic.is_a?(::RBS::InlineParser::Diagnostic::UnusedInlineAnnotation)

              add_offense(location_to_range(diagnostic.location), message: diagnostic.message)
            end
          end
        end
      end
    end
  end
end
