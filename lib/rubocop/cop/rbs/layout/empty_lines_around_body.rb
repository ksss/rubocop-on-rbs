# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # @rbs module-self: RuboCop::RBS::CopBase
        module EmptyLinesAroundBody
          MSG_EXTRA = 'Extra empty line detected at %<kind>s body %<location>s.'

          private

          # Main endpoint
          #: (untyped decl) -> void
          def check(decl)
            first_line = decl.location.start_line
            last_line = decl.location.end_line
            return if last_line == first_line

            check_beginning(first_line)
            check_ending(last_line)
          end

          # Check line after `class/module/interface`
          #: (Integer first_line) -> void
          def check_beginning(first_line)
            check_source(first_line, 'beginning')
          end

          # Check line before `end`
          #: (Integer last_line) -> void
          def check_ending(last_line)
            check_source(last_line - 2, 'end')
          end

          #: (Integer line_no, untyped desc) -> void
          def check_source(line_no, desc)
            return unless line_no.positive?
            return unless processed_source.lines[line_no]
            return unless processed_source.lines[line_no].empty?

            range = source_range(processed_source.buffer, line_no + 1, 0)
            message = message(MSG_EXTRA, desc)
            add_offense(range, message: message) do |corrector|
              corrector.remove(range)
            end
          end

          def message(type, location)
            format(type, kind: self.class::KIND, location: location)
          end
        end
      end
    end
  end
end
