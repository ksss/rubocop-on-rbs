# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Style
        # Checks that `instance` in instance context.
        #
        # @example
        #   # bad
        #   #: (instance) -> instance
        #   def foo(x)
        #   end
        #
        #   # good
        #   #: (self) -> self
        #   def foo(x)
        #   end
        #
        class InstanceWithInstance < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::InstanceWithInstance
          extend AutoCorrector

          alias on_inline_class check_class
        end
      end
    end
  end
end
