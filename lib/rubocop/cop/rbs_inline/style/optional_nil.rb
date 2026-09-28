# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Style
        # `nil?` is the same as `nil`.
        #
        # @example
        #   # bad
        #   # @rbs x: nil?
        #   def foo(x)
        #   end
        #
        #   # good
        #   # @rbs x: nil
        #   def foo(x)
        #   end
        #
        class OptionalNil < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::OptionalNil
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
