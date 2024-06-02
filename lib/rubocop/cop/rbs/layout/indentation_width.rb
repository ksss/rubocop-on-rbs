# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # @example default
        #   # bad
        #   class Foo
        #   def foo: () -> void
        #   end
        #
        #   # good
        #   class Foo
        #     def foo: () -> void
        #   end
        class IndentationWidth < Base
          extend AutoCorrector

          def on_rbs_new_investigation
            processed_rbs_source.decls.each do |decl|
              check_indentation(decl, expect: 0)
            end
          end

          def check_indentation(decl, expect:)
            if decl.respond_to?(:members)
              check(decl, expect: expect)
              decl.members.each do |member|
                check_indentation(member, expect: expect + 2)
              end
            else
              check(decl, expect: expect)
            end
          end

          def check(decl, expect:)
            line_start_pos = line_start_pos(decl)
            actual = decl.location.start_pos - line_start_pos
            if actual != expect
              range = range_between(line_start_pos, decl.location.start_pos)
              message = "Use #{expect} (not #{actual}) spaces for indentation."
              add_offense(range, message: message) do |corrector|
                corrector.replace(range, ' ' * expect)
              end
            end
          end

          def line_start_pos(decl)
            rindex = processed_source.raw_source.rindex(/\R/, decl.location.start_pos)
            if rindex
              rindex + 1
            else
              0
            end
          end
        end
      end
    end
  end
end
