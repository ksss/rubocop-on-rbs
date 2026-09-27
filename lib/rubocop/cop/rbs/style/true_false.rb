# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # `true | false` is simply the same as `bool`.
        #
        # @example
        #   # bad
        #   def foo: (true | false) -> (true | false)
        #
        #   # bad
        #   def foo: (TrueClass | FalseClass) -> (TrueClass | FalseClass)
        #
        #   # good
        #   def foo: (bool) -> bool
        #
        class TrueFalse < RuboCop::RBS::CopBase
          include RuboCop::Cop::RBS::Mixin::TrueFalse
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
