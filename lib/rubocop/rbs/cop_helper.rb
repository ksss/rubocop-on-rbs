# frozen_string_literal: true

module RuboCop
  module RBS
    # Helpers shared by `RuboCop::RBS::CopBase` and `RuboCop::RBSInline::CopBase`.
    # `RuboCop::Cop::RBS::Mixin::*` depend on this module as their self type.
    module CopHelper
      include RuboCop::Cop::RangeHelp
      include RuboCop::RBS::OnTypeHelper

      #: (::RBS::Location[untyped, untyped]) -> Parser::Source::Range
      def location_to_range(location)
        range_between(location.start_pos, location.end_pos)
      end

      #: (String) -> Array[::RBS::Parser::Token]
      def tokenize(source)
        ::RBS::Parser.lex(source).value.reject { |t| t.type == :tTRIVIA }
      end
    end
  end
end
