# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Lint
        # Checks that there are void types in the return type of `.new` method
        # `self.new` is a special and fundamental method, and extra care should be taken regarding its return value.
        # In most cases, assigning it `void` is an unintended mistake.
        #
        # @example
        #   # bad
        #   def self.new #: void
        #   end
        #
        #   # good
        #   def self.new #: instance
        #   end
        #
        class NewReturnsVoid < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::NewReturnsVoid

          alias on_inline_def check_def
        end
      end
    end
  end
end
