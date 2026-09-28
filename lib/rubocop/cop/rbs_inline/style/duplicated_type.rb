# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Style
        # Unions and intersections of the same type are meaningless.
        #
        # @example
        #   # bad
        #   # @rbs x: Integer | Integer
        #   def foo(x)
        #   end
        #
        #   # bad
        #   #: (Integer & Integer) -> void
        #   def foo(x)
        #   end
        #
        #   # good
        #   # @rbs x: Integer
        #   def foo(x)
        #   end
        #
        class DuplicatedType < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::DuplicatedType
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
