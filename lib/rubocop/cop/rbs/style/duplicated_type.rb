# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # Unions and intersections of the same type are meaningless.
        #
        # @example
        #   # bad
        #   def foo: (Integer | Integer) -> void
        #
        #   # bad
        #   def foo: (Integer & Integer) -> void
        #
        #   # good
        #   def foo: (Integer) -> void
        #
        class DuplicatedType < RuboCop::RBS::CopBase
          include RuboCop::Cop::RBS::Mixin::DuplicatedType
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
