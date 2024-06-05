# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Style
        # @example default
        #   # bad
        #   def foo: (untyped?) -> untyped?
        #
        #   # bad
        #   def foo: (Integer | untyped) -> (Integer | untyped)
        #
        #   # bad
        #   def foo: (Integer & untyped) -> (Integer & untyped)
        #
        #   # good
        #   def foo: (untyped) -> untyped
        class MergeUntyped < RuboCop::RBS::CopBase
          extend AutoCorrector

          # @sig decl: ::RBS::AST::Members::MethodDefinition
          def on_rbs_def(decl)
            decl.overloads.each do |overload|
              overload.method_type.type.tap do |fun|
                fun.each_param do |param|
                  check_type(param.type)
                end
                check_type(fun.return_type)
              end
            end
          end

          def check_type(type)
            find_replacement(type) do |method, t, replaced|
              case method
              when :replace
                range = location_to_range(t.location)
                add_offense(range, message: "Use `#{replaced}` instead of `#{t}`") do |corrector|
                  corrector.replace(range, replaced.to_s)
                end
              when :remove
                range = t
                add_offense(range, message: "Remove `?` in Optional") do |corrector|
                  corrector.remove(range)
                end
              end
            end
          end

          def find_replacement(type, &block)
            case type
            when ::RBS::Types::Optional
              case type.type
              when ::RBS::Types::Bases::Any,
                   ::RBS::Types::Bases::Nil,
                   ::RBS::Types::Bases::Void,
                   ::RBS::Types::Bases::Top,
                   ::RBS::Types::Bases::Bottom
                # untyped? => untyped
                block.call([:replace, type, type.type])
              when ::RBS::Types::Optional
                # (Integer?)? => Integer?
                range = Parser::Source::Range.new(processed_source.buffer, type.type.location.end_pos - 1,
                                                  type.type.location.end_pos)
                block.call([:remove, range])
                find_replacement(type.type, &block)
              when ::RBS::Types::Union, ::RBS::Types::Intersection
                find_replacement(type.type, &block)
              end
            when ::RBS::Types::Union, ::RBS::Types::Intersection
              # (untyped | Integer) => untyped
              # (untyped & Integer) => untyped
              if type.types.any? { |t| t.is_a?(::RBS::Types::Bases::Any) }
                block.call([:replace, type, 'untyped'])
              end

              uniqed = type.types.uniq
              if uniqed.size < type.types.size
                block.call([:replace, type, type.class.new(types: uniqed, location: nil)])
              end
              type.types.each do |t|
                find_replacement(t, &block)
              end
            end
          end
        end
      end
    end
  end
end
