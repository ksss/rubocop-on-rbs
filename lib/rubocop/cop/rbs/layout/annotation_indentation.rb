# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # Checks the indentation of annotations in RBS.
        #
        # @example
        #   # bad
        #   # comment
        #     %a{pure}
        #   def foo: () -> void
        #
        #   # good
        #   # comment
        #   %a{pure}
        #   def foo: () -> void
        #
        class AnnotationIndentation < RuboCop::RBS::CopBase
          extend AutoCorrector

          MSG = "Incorrect indentation detected (column %<expect>s instead of %<actual>s)."

          def on_rbs_new_investigation
            indent_start_lines = Set.new
            indent_end_lines = Set.new
            ignore_poses = Set.new
            processed_rbs_source.decls.each do |decl|
              walk_decl(decl) do |d|
                indent_start_lines << d.location.start_line
                indent_end_lines << d.location.end_line
                d.members.each do |member|
                  case member
                  when ::RBS::AST::Members::MethodDefinition
                    member.overloads.each do |overload|
                      overload.annotations.each do |annotation|
                        ignore_poses << annotation.location.start_pos
                      end
                    end
                  end
                end
              end
            end

            expected_width = 0
            last_annotation_line = -1
            processed_rbs_source.tokens.each do |token|
              case token.type
              when :kMODULE, :kCLASS, :kINTERFACE
                next unless indent_start_lines.include?(token.location.start_line)

                expected_width += 2
              when :kEND
                next unless indent_end_lines.include?(token.location.start_line)

                expected_width -= 2
              when :tANNOTATION
                next if ignore_poses.include?(token.location.start_pos)
                if token.location.start_column == expected_width
                  last_annotation_line = token.location.start_line
                  next
                end
                next if last_annotation_line == token.location.start_line

                token_range = location_to_range(token.location)
                message = format(MSG, expect: expected_width, actual: token.location.start_column)
                last_annotation_line = token.location.start_line
                add_offense(token_range, message: message) do |corrector|
                  line_start_pos = processed_source.buffer.line_range(token.location.start_line).begin_pos
                  indent = range_between(line_start_pos, token.location.start_pos)
                  corrector.replace(indent, ' ' * expected_width)
                end
              end
            end
          end

          def walk_decl(decl, &block)
            if decl.respond_to?(:members)
              yield decl
              decl.members.each { |member| walk_decl(member, &block) }
            end
          end
        end
      end
    end
  end
end
