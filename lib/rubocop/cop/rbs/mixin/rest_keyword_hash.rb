# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Mixin
        # Shared implementation of `RBS/Lint/RestKeywordHash` and `RBSInline/Lint/RestKeywordHash`.
        # @rbs module-self: RuboCop::Cop::Base
        # @rbs module-self: RuboCop::RBS::CopHelper
        module RestKeywordHash
          #: (::RBS::AST::Members::MethodDefinition | ::RBS::AST::Ruby::Members::DefMember decl) -> void
          def check_def(decl)
            decl.overloads.each do |overload|
              func = overload.method_type.type
              next unless func.is_a?(::RBS::Types::Function)

              if !func.rest_keywords.nil?
                check_type(func.rest_keywords.type)
              end
            end
          end

          #: (::RBS::Types::t type) -> void
          def check_type(type)
            case type
            when ::RBS::Types::ClassInstance
              if type.name.relative!.to_s == 'Hash'
                did_you_mean = type.args[1] or return
                range = location_to_range(type.location)
                message = "The type of `**` specifies only the type of value. " \
                          "Did you mean `**#{did_you_mean}`?"
                add_offense(range, message:)
              end
            end
          end
        end
      end
    end
  end
end
