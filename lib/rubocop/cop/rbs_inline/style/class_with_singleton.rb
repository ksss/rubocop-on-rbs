# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Style
        # Checks that `class` in singleton context.
        #
        # @example
        #   # bad
        #   #: (class) -> class
        #   def self.foo(x)
        #   end
        #
        #   # good
        #   #: (self) -> self
        #   def self.foo(x)
        #   end
        #
        class ClassWithSingleton < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::ClassWithSingleton
          extend AutoCorrector

          alias on_inline_def check_def
        end
      end
    end
  end
end
