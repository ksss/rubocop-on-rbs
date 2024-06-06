# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Checks that there are no repeated overload bodies
        #
        # @example default
        #   # bad
        #   def foo: () -> void
        #          | () -> void
        #
        class DuplicateOverload < RuboCop::RBS::CopBase
          MSG = 'Duplicate overload body detected.'

          def on_rbs_def(decl)
            overloads = decl.overloads
            overloads.each_with_index do |overload, idx|
              next if idx == overloads.size - 1

              next_overloads = overloads[(idx + 1)..-1]
              next_overloads.each do |next_overload|
                next unless overload.method_type == next_overload.method_type

                range = location_to_range(next_overload.method_type.location)
                add_offense(range)
              end
            end
          end
        end
      end
    end
  end
end
