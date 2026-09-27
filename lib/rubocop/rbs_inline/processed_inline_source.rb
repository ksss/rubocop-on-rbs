# frozen_string_literal: true

require 'prism'

module RuboCop
  module RBSInline
    # Parse result of RBS inline annotations in a Ruby file.
    # Built once per file and shared across all RBSInline cops.
    class ProcessedInlineSource
      attr_reader :buffer #: ::RBS::Buffer
      attr_reader :result #: ::RBS::InlineParser::Result

      #: (RuboCop::ProcessedSource processed_source) -> void
      def initialize(processed_source)
        @buffer = ::RBS::Buffer.new(
          name: Pathname(processed_source.buffer.name),
          content: processed_source.raw_source
        )
        @result = ::RBS::InlineParser.parse(@buffer, Prism.parse(processed_source.raw_source))
      end

      #: () -> Array[::RBS::AST::Ruby::Declarations::t]
      def declarations
        result.declarations
      end

      #: () -> Array[::RBS::InlineParser::Diagnostic::Base]
      def diagnostics
        result.diagnostics
      end
    end
  end
end
