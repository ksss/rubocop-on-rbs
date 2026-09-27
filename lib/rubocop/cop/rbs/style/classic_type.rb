# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # @example
        #   # bad
        #   def foo: () -> TrueClass
        #
        #   # bad
        #   def bar: () -> NilClass
        #
        #   # good
        #   def foo: () -> true
        #
        #   # good
        #   def bar: () -> nil
        #
        class ClassicType < RuboCop::RBS::CopBase
          include RuboCop::Cop::RBS::Mixin::ClassicType
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
