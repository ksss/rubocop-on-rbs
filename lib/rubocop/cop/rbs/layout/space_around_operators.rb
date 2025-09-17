# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Layout
        # @example
        #   # bad
        #   Integer|String
        #
        #   # good
        #   Integer | String
        #
        class SpaceAroundOperators < RuboCop::RBS::CopBase
          extend AutoCorrector

          def on_rbs_class(decl)
            check_type_params(decl)
          end
          alias on_rbs_module on_rbs_class
          alias on_rbs_interface on_rbs_class

          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              check_type_params(overload.method_type)
              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          def on_rbs_constant(decl)
            check_type(decl.type)
          end
          alias on_rbs_global on_rbs_constant
          alias on_rbs_attribute on_rbs_constant
          alias on_rbs_var on_rbs_constant

          def on_rbs_type_alias(decl)
            check_type_params(decl)
            check_type(decl.type)
          end

          def check_type(type)
            case type
            when ::RBS::Types::Union
              check_operator(type, '|')
            when ::RBS::Types::Intersection
              check_operator(type, '&')
            end
            type.each_type do |t|
              check_type(t)
            end
          end

          def check_type_params(decl)
            decl.type_params.each do |type_param|
              check_type(type_param.default_type) if type_param.default_type
              check_type(type_param.upper_bound_type) if type_param.upper_bound_type
            end
          end

          def check_operator(type, operator)
            type.types.each_cons(2) do |before, after|
              next unless before.location.end_line == after.location.start_line

              operator_index = type.location.source.index(
                operator,
                before.location.end_pos - type.location.start_pos
              ) or raise
              operator_index += type.location.start_pos
              operator_range = range_between(operator_index, operator_index + 1)

              before_char = processed_source.raw_source[operator_index - 1]
              if before_char != ' '
                add_offense(operator_range, message: "Use one space before `#{operator}`.") do |corrector|
                  corrector.insert_before(operator_range, ' ')
                end
              end

              after_char = processed_source.raw_source[operator_index + 1]
              if after_char != ' '
                add_offense(operator_range, message: "Use one space after `#{operator}`.") do |corrector|
                  corrector.insert_after(operator_range, ' ')
                end
              end
            end
          end
        end
      end
    end
  end
end
