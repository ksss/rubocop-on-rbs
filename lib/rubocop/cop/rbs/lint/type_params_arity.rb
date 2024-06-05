# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # This cop checks the arity of type parameters arity.
        # You can add expect settings in your .rubocop.yml.
        #
        # @example Expects settings
        #   RBS/Lint/TypeParamsArity:
        #     Expects:
        #       Your::Class: 1
        #
        # @example default
        #   # bad
        #   type a = Array[Integer, String, Symbol]
        #
        #   # bad
        #   class Foo
        #     include Enumerable
        #   end
        class TypeParamsArity < RuboCop::RBS::CopBase
          Types = ::RBS::Types

          def on_rbs_module(decl)
            check_type_params(decl)
            decl.self_types.each do |self_type|
              check(
                name: self_type.name,
                args: self_type.args,
                location: self_type.location
              )
            end
            check_each_mixin(decl)
          end

          def on_rbs_class(decl)
            check_type_params(decl)
            if decl.super_class
              check(
                name: decl.super_class.name,
                args: decl.super_class.args,
                location: decl.super_class.location
              )
            end
            check_each_mixin(decl)
          end

          def on_rbs_interface(decl)
            check_type_params(decl)
            check_each_mixin(decl)
          end

          def on_rbs_constant(const)
            check_type(const.type)
          end

          def on_rbs_global(global)
            check_type(global.type)
          end

          def on_rbs_type_alias(decl)
            check_type_params(decl)
            check_type(decl.type)
            decl.type.each_type do |type|
              check_type(type)
            end
          end

          def on_rbs_def(member)
            member.overloads.each do |overload|
              overload.method_type.each_type do |type|
                check_type(type)
              end
            end
          end

          def on_rbs_attribute(attr)
            check_type(attr.type)
          end

          def check_each_mixin(decl)
            decl.each_mixin do |mixin|
              check(
                name: mixin.name,
                args: mixin.args,
                location: mixin.location
              )
            end
          end

          def check_type_params(decl)
            decl.type_params.each do |type_param|
              if type_param.upper_bound
                check(
                  name: type_param.upper_bound.name,
                  args: type_param.upper_bound.args,
                  location: type_param.upper_bound.location
                )
              end
            end
          end

          def check_type(type)
            case type
            when Types::Record,
                 Types::Tuple,
                 Types::Union,
                 Types::Intersection,
                 Types::Optional,
                 Types::Proc
              type.each_type.each do |t|
                check_type(t)
              end
            when Types::Interface,
                 Types::Alias,
                 Types::ClassInstance
              check(
                name: type.name,
                args: type.args,
                location: type.location,
              )
            end
          end

          def check(name:, args:, location:)
            return unless name.absolute?
            return unless location

            expect_size = expects[name.to_s]
            return unless expect_size
            return unless expect_size != args.size

            message = if args.size == 0
                        "Type `#{name}` is generic but used as a non generic type."
                      else
                        "Type `#{name}` expects #{expect_size} arguments, but #{args.size} arguments are given."
                      end
            add_offense(
              location_to_range(location),
              message: message,
              severity: :error
            )
          end

          def expects
            @expects ||= begin
              expects = cop_config['Expects']
              raise "Expects must be a hash" unless expects.is_a?(Hash)

              unless expects.all? { |k, _| k.is_a?(String) }
                raise "[RBS/Lint/TypeParamsArity] Keys of Expects must be strings"
              end
              unless expects.all? { |_, v| v.is_a?(Integer) }
                raise "[RBS/Lint/TypeParamsArity] Values of Expects must be integers"
              end

              expects.transform_keys! do |k|
                k.start_with?('::') ? k : "::#{k}"
              end

              expects
            end
          end
        end
      end
    end
  end
end
