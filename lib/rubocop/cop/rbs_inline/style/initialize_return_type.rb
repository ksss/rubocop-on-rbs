# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Style
        # `#initialize` is a private method and is likely to be overridden.
        # The return type of `#initialize` should not be specific.
        #
        # @example
        #   # bad
        #   def initialize #: nil
        #   end
        #
        #   # bad
        #   # @rbs return: false
        #   def initialize
        #   end
        #
        #   # good
        #   def initialize #: untyped
        #   end
        #
        #   # good
        #   def initialize #: void
        #   end
        #
        class InitializeReturnType < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::InitializeReturnType
          extend AutoCorrector

          alias on_inline_def check_def
        end
      end
    end
  end
end
