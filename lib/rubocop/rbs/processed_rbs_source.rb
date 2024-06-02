# frozen_string_literal: true

module RuboCop
  module RBS
    # Fake for RuboCop::ProcessedSource
    class ProcessedRBSSource
      attr_reader :raw_source
      attr_reader :source
      attr_reader :buffer
      attr_reader :directives
      attr_reader :decls
      attr_reader :error

      def initialize(source)
        @source = source
        @raw_source = source.content
        @buffer, @directives, @decls = ::RBS::Parser.parse_signature(source)
        @error = nil
        @tokens = nil
      rescue ::RBS::ParsingError => e
        @error = e
      end

      def tokens
        @tokens ||= begin
          ::RBS::Parser.lex(buffer).value
        end
      end
    end
  end
end
