# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # `nil?` is the same as `nil`.
        #
        # @example
        #   # bad
        #   def foo: (nil?) -> void
        #
        #   # good
        #   def foo: (nil) -> void
        #
        class OptionalNil < RuboCop::RBS::CopBase
          include RuboCop::Cop::RBS::Mixin::OptionalNil
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
