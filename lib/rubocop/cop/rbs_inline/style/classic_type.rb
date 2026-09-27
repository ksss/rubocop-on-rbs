# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Style
        # @example
        #   # bad
        #   def foo #: TrueClass
        #   end
        #
        #   # bad
        #   # @rbs return: NilClass
        #   def bar
        #   end
        #
        #   # good
        #   def foo #: true
        #   end
        #
        #   # good
        #   # @rbs return: nil
        #   def bar
        #   end
        #
        class ClassicType < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::ClassicType
          extend AutoCorrector

          alias on_inline_def check_def
          alias on_inline_constant check_member
          alias on_inline_attribute check_member
          alias on_inline_var check_member
        end
      end
    end
  end
end
