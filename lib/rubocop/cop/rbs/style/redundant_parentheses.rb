# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # Check for redundant parentheses.
        #
        # @example
        #   # bad
        #   def foo: () -> (bool)
        #
        #   # bad
        #   def foo: (((true | false))) -> void
        #
        #   # good
        #   def foo: () -> bool
        #
        #   # good
        #   def foo: ((true | false)) -> bool
        #
        class RedundantParentheses < RuboCop::RBS::CopBase
          include RuboCop::Cop::RBS::Mixin::RedundantParentheses
          extend AutoCorrector

          def on_rbs_def(decl)
            location = decl.location or return
            tokens = tokenize(location.source)
            decl.overloads.each do |overload|
              check_method_type(overload.method_type, tokens:, base: location.start_pos)
            end
          end

          def on_rbs_constant(member) = check_type_at(member.type, member.location)
          alias on_rbs_global on_rbs_constant
          alias on_rbs_type_alias on_rbs_constant
          alias on_rbs_attribute on_rbs_constant
          alias on_rbs_var on_rbs_constant
        end
      end
    end
  end
end
