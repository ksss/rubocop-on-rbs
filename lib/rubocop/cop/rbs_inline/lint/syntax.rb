# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Lint
        # Checks syntax of RBS inline annotations.
        #
        # RDoc directives such as `#:nodoc:` are ignored.
        # Use `AllowedPatterns` to ignore other comments that look like annotations.
        # By default, `# @rbs!` (embedded RBS by rbs-inline gem) is allowed.
        #
        # @example
        #   # bad
        #   def foo #: Strin g
        #   end
        #
        #   # good
        #   def foo #: String
        #   end
        #
        class Syntax < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::AllowedPattern

          def on_inline_new_investigation
            processed_inline_source.diagnostics.each do |diagnostic|
              next unless diagnostic.is_a?(::RBS::InlineParser::Diagnostic::AnnotationSyntaxError)

              comment = processed_source.comment_at_line(diagnostic.location.start_line)
              next if comment && (!inline_annotation_comment?(comment) || matches_allowed_pattern?(comment.text))

              message = "#{diagnostic.message}, token=`#{diagnostic.location.source}`"
              add_offense(location_to_range(diagnostic.location), message:)
            end
          end
        end
      end
    end
  end
end
