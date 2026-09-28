# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Checks that there are no repeated overload bodies
        #
        # @example default
        #   # bad
        #   1 & 2
        #
        #   # bad
        #   1 & _Foo
        #
        class LiteralIntersection < RuboCop::RBS::CopBase
          include RuboCop::Cop::RBS::Mixin::LiteralIntersection

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
