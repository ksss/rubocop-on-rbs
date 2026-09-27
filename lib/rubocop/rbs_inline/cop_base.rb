# frozen_string_literal: true

module RuboCop
  module RBSInline
    # Base class for cops that operate on RBS inline annotations in Ruby files.
    #
    # Performance notes:
    # - RuboCop discards the Prism parse result, so the file is parsed again with Prism.
    #   To keep this cheap, parsing happens only when a file has an annotation-like comment,
    #   only when a cop actually calls `processed_inline_source`, and only once per file
    #   regardless of how many RBSInline cops are enabled.
    class CopBase < RuboCop::Cop::Base
      # @rbs @processed_inline_source: ProcessedInlineSource?

      include RuboCop::Cop::RangeHelp

      exclude_from_registry

      # `#:nodoc:`, `#:stopdoc:`, `#:call-seq:` ... are RDoc directives, not RBS annotations.
      RDOC_DIRECTIVE = /\A#:[\w-]+:/

      # Shared across cops. Keyed by ProcessedSource so an entry dies with its file.
      # WeakKeyMap (not WeakMap) because values must stay alive while the key does.
      CACHE = ObjectSpace::WeakKeyMap.new

      def self.documentation_url(_config = nil)
        base = "cops_#{department.to_s.downcase.tr('/', '_')}"
        fragment = cop_name.downcase.gsub(/[^a-z]/, '')
        "https://github.com/ksss/rubocop-on-rbs/blob/v#{RuboCop::RBS::VERSION}/docs/modules/ROOT/pages/#{base}.adoc##{fragment}"
      end

      def on_new_investigation
        @processed_inline_source = nil
        return if processed_source.buffer.name.end_with?('.rbs')
        return unless processed_source.comments.any? { |comment| inline_annotation_comment?(comment) }

        on_inline_new_investigation
      end

      #: () -> void
      def on_inline_new_investigation; end

      #: () -> ProcessedInlineSource
      def processed_inline_source
        @processed_inline_source ||= CACHE[processed_source] ||= ProcessedInlineSource.new(processed_source)
      end

      #: (Parser::Source::Comment) -> bool
      def inline_annotation_comment?(comment)
        text = comment.text
        return !RDOC_DIRECTIVE.match?(text) if text.start_with?('#:')

        text.start_with?('#[') || text.match?(/\A#\s*@rbs\b/)
      end

      #: (::RBS::Location[untyped, untyped]) -> Parser::Source::Range
      def location_to_range(location)
        range_between(location.start_pos, location.end_pos)
      end
    end
  end
end
