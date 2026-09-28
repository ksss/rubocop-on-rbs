# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Lint
        # Checks that there are no literals in intersection types.
        #
        # @example default
        #   # bad
        #   #: (1 & 2) -> void
        #   def foo(x)
        #   end
        #
        #   # bad
        #   # @rbs x: 1 & _Foo
        #   def foo(x)
        #   end
        #
        class LiteralIntersection < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::LiteralIntersection

          alias on_inline_def check_def
          alias on_inline_constant check_member
          alias on_inline_attribute check_member
          alias on_inline_var check_member
        end
      end
    end
  end
end
