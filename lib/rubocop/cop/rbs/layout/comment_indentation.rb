# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks the indentation of comments in RBS.
        #
        # @example
        #   # bad
        #     # comment here
        #   def foo: () -> void
        #
        #   # good
        #   # comment here
        #   def foo: () -> void
        #
        class CommentIndentation < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = "Incorrect indentation detected (column %<expect>s instead of %<actual>s)."

          def on_rbs_new_investigation
            comments = processed_rbs_source.tokens.select { |token| token.type == :tLINECOMMENT }
            comments.each_with_index do |token, comment_index|
              check(token, comment_index)
            end
          end

          def check(comment_token, _comment_index)
            next_line = line_after_comment(comment_token)
            correct_comment_indentation = correct_indentation(next_line)
            column = comment_token.location.start_column

            column_delta = correct_comment_indentation - column
            return if column_delta.zero?

            token_range = location_to_range(comment_token.location)
            message = format(MSG, expect: correct_comment_indentation, actual: column)
            add_offense(token_range, message: message) do |corrector|
              line_start_pos = processed_source.buffer.line_range(comment_token.location.start_line).begin_pos
              indent = range_between(line_start_pos, comment_token.location.start_pos)
              corrector.replace(indent, ' ' * correct_comment_indentation)
            end
          end

          def line_after_comment(comment)
            lines = processed_source.lines
            lines[comment.location.start_line..].find { |line| !line.blank? }
          end

          def correct_indentation(next_line)
            return 0 unless next_line

            indentation_of_next_line = next_line =~ /\S/
            indentation_of_next_line + if less_indented?(next_line)
                                         2
                                       else
                                         0
                                       end
          end

          def less_indented?(line)
            /\A\s*end\b/.match?(line)
          end
        end
      end
    end
  end
end
