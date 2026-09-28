# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Lint
        # Checks that there are no repeated overload bodies.
        # This cop ignores the difference of return type.
        #
        # @example
        #   # bad
        #   #: () -> void
        #   #: () -> top
        #   def foo
        #   end
        #
        #   # bad
        #   # @rbs () -> void
        #   #    | () -> top
        #   def foo
        #   end
        #
        class DuplicateOverload < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::DuplicateOverload

          alias on_inline_def check_def
        end
      end
    end
  end
end
