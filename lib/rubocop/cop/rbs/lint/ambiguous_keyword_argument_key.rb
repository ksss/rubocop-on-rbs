# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Checks keyword argument keys that are not local variable names.
        #
        # @example default
        #   # bad
        #   def foo: (option?: bool, option!: bool, Option: bool) -> void
        #
        class AmbiguousKeywordArgumentKey < RuboCop::RBS::CopBase
          include RuboCop::Cop::RBS::Mixin::AmbiguousKeywordArgumentKey
          extend AutoCorrector

          alias on_rbs_def check_def
        end
      end
    end
  end
end
