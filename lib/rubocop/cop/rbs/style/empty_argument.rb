# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # Checks parentheses for empty arguments.
        #
        # @example
        #   # bad
        #   def foo: -> void
        #
        #   # bad
        #   def foo: () { -> void } -> void
        #
        #   # bad
        #   def foo: () -> ^ -> void
        #
        #   # good
        #   def foo: () { () -> void } -> ^() -> void
        #
        class EmptyArgument < RuboCop::RBS::CopBase
          include RuboCop::Cop::RBS::Mixin::EmptyArgument
          extend AutoCorrector

          alias on_rbs_def check_def
          alias on_rbs_constant check_member
          alias on_rbs_global check_member
          alias on_rbs_type_alias check_member
          alias on_rbs_attribute check_member
          alias on_rbs_var check_member
        end
      end
    end
  end
end
