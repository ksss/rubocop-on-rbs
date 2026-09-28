# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Lint
        # Specifying the `Hash` type for `**` is a very special case and,
        # in most situations, it is a mistake in type specification.
        #
        # @example
        #   # bad
        #   # @rbs **opts: Hash[Symbol, String]
        #   def foo(**opts)
        #   end
        #   # e.g.) foo(a: {x: "x"}, b: {y: "y"}, c: {z: "z"})
        #
        #   # good
        #   # @rbs **opts: String
        #   def foo(**opts)
        #   end
        #   # e.g.) foo(a: "x", b: "y", c: "z")
        #
        class RestKeywordHash < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::RestKeywordHash

          alias on_inline_def check_def
        end
      end
    end
  end
end
