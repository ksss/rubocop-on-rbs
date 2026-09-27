# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Style
        # @example
        #   # bad
        #   #: () { () -> bool } -> void
        #   def foo
        #   end
        #
        #   # good
        #   #: () { () -> boolish } -> void
        #   def foo
        #   end
        #
        class BlockReturnBoolish < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::BlockReturnBoolish
          extend AutoCorrector

          alias on_inline_def check_def
        end
      end
    end
  end
end
