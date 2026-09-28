# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Lint
        # Notice unused overload type parameters.
        #
        # @example
        #   # bad
        #   #: [T] () -> void
        #   def foo
        #   end
        #
        #   # good
        #   #: [T] (T) -> T
        #   def foo(x)
        #   end
        #
        class UnusedOverloadTypeParams < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::UnusedOverloadTypeParams

          alias on_inline_def check_def
        end
      end
    end
  end
end
