# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Style
        # Checks parentheses for empty arguments.
        #
        # @example
        #   # bad
        #   #: -> void
        #   def foo
        #   end
        #
        #   # bad
        #   #: () { -> void } -> void
        #   def foo
        #   end
        #
        #   # bad
        #   # @rbs return: ^ -> void
        #   def foo
        #   end
        #
        #   # good
        #   #: () { () -> void } -> ^() -> void
        #   def foo
        #   end
        #
        class EmptyArgument < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::EmptyArgument
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
