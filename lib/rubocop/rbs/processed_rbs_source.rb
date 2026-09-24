# frozen_string_literal: true

module RuboCop
  module RBS
    # Fake for RuboCop::ProcessedSource
    class ProcessedRBSSource
      # @rbs @tokens: ::Array[::RBS::Parser::Token]?

      attr_reader :raw_source #: String
      attr_reader :source
      attr_reader :buffer #: ::RBS::Buffer
      attr_reader :directives #: ::Array[::RBS::AST::Directives::t]
      attr_reader :decls #: ::Array[::RBS::AST::Declarations::t]
      attr_reader :error #: ::RBS::ParsingError?

      #: (::RBS::Buffer source) -> void
      def initialize(source)
        @raw_source = source.content
        @buffer, @directives, @decls = ::RBS::Parser.parse_signature(source)
        @error = nil
        @tokens = nil
      rescue ::RBS::ParsingError => e
        @error = e
      end

      def valid_syntax?
        @error.nil?
      end

      #: () -> ::Array[::RBS::Parser::Token]
      def tokens
        @tokens ||= ::RBS::Parser.lex(buffer).value
      end
    end
  end
end
