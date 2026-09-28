# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Lint
        # Checks keyword argument keys that are not local variable names.
        #
        # @example default
        #   # bad
        #   #: (option?: bool, option!: bool, Option: bool) -> void
        #   def foo(**)
        #   end
        #
        #   # good
        #   #: (?option: bool) -> void
        #   def foo(option: false)
        #   end
        #
        class AmbiguousKeywordArgumentKey < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::AmbiguousKeywordArgumentKey

          alias on_inline_def check_def
        end
      end
    end
  end
end
