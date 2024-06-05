# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # @example default
        #   # bad
        #   def foo: (nil?) -> void
        #
        #   # good
        #   def foo: (nil) -> void
        class OptionalNil < RuboCop::RBS::CopBase
          extend AutoCorrector

          # @sig decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              overload.method_type.each_type do |type|
                find_replacement(type) do |t, replaced|
                  range = location_to_range(t.location)
                  add_offense(range, message: "Use `#{replaced}` instead of `#{t}`") do |corrector|
                    corrector.replace(range, replaced.to_s)
                  end
                end
              end
            end
          end

          # @rbs type: ::RBS::Types::t
          def find_replacement(type, &block)
            case type
            when ::RBS::Types::Optional
              case type.type
              when ::RBS::Types::Bases::Nil
                block.call([type, ::RBS::Types::Bases::Nil.new(location: nil)])
              else
                find_replacement(type.type, &block)
              end
            else
              type.each_type do |type|
                find_replacement(type, &block)
              end
            end
          end
        end
      end
    end
  end
end
