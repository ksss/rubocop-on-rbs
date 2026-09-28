# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Style
        # `true | false` is simply the same as `bool`.
        #
        # @example
        #   # bad
        #   #: (true | false) -> (true | false)
        #   def foo(x)
        #   end
        #
        #   # bad
        #   # @rbs x: TrueClass | FalseClass
        #   def foo(x)
        #   end
        #
        #   # good
        #   #: (bool) -> bool
        #   def foo(x)
        #   end
        #
        class TrueFalse < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::TrueFalse
          extend AutoCorrector

          alias on_inline_def check_def
          alias on_inline_constant check_member
          alias on_inline_attribute check_member
          alias on_inline_var check_member
        end
      end
    end
  end
end
