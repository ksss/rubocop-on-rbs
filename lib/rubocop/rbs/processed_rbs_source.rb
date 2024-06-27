# frozen_string_literal: true

module RuboCop
  module RBS
    class ProcessedRBSSource
      attr_reader :raw_source
      attr_reader :source
      attr_reader :buffer
      attr_reader :directives
      attr_reader :decls
      attr_reader :error

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

      def tokens(with_trivia: false)
        @tokens ||= begin
          tokens = ::RBS::Parser.lex(buffer).value
          tokens.reject! { |token| token.type == :tTRIVIA } unless with_trivia
          tokens
        end
      end
    end
  end
end
