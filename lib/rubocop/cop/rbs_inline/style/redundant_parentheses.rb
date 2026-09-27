# frozen_string_literal: true

module RuboCop
  module Cop
    module RBSInline
      module Style
        # Check for redundant parentheses.
        #
        # @example
        #   # bad
        #   #: () -> (bool)
        #   def foo
        #   end
        #
        #   # bad
        #   # @rbs x: (((true | false)))
        #   def foo(x)
        #   end
        #
        #   # good
        #   #: () -> bool
        #   def foo
        #   end
        #
        #   # good
        #   # @rbs x: (true | false)
        #   def foo(x)
        #   end
        #
        class RedundantParentheses < RuboCop::RBSInline::CopBase
          include RuboCop::Cop::RBS::Mixin::RedundantParentheses
          extend AutoCorrector

          Annotations = ::RBS::AST::Ruby::Annotations #: module-alias

          def on_inline_def(decl)
            case (annotations = decl.method_type.type_annotations)
            when Array
              # `#: () -> void` style. Each overload has its own method type location.
              decl.overloads.each do |overload|
                location = overload.method_type.location or next
                check_method_type(overload.method_type, tokens: tokenize(location.source), base: location.start_pos)
              end
            when ::RBS::AST::Ruby::Members::MethodTypeAnnotation::DocStyle
              # `# @rbs x: Integer` style. Each annotation is checked with its own tokens.
              check_doc_style(annotations)
            end
          end

          def on_inline_constant(decl) = check_type_at(decl.type, decl.type_annotation&.location)
          alias on_inline_attribute on_inline_constant

          def on_inline_var(member) = check_type_at(member.type, member.annotation.location)

          private

          #: (::RBS::AST::Ruby::Members::MethodTypeAnnotation::DocStyle doc) -> void
          def check_doc_style(doc)
            doc.all_param_annotations.each do |annotation|
              case annotation
              when Annotations::ParamTypeAnnotation,
                   Annotations::SplatParamTypeAnnotation,
                   Annotations::DoubleSplatParamTypeAnnotation
                check_type_at(annotation.param_type, annotation.location)
              when Annotations::BlockParamTypeAnnotation
                check_block_annotation(annotation)
              end
            end

            case (ret = doc.return_type_annotation)
            when Annotations::ReturnTypeAnnotation
              check_type_at(ret.return_type, ret.location)
            when Annotations::NodeTypeAssertion
              check_type_at(ret.type, ret.location)
            end
          end

          # `# @rbs &block: (Integer) -> void` holds a function, not a type.
          #: (::RBS::AST::Ruby::Annotations::BlockParamTypeAnnotation annotation) -> void
          def check_block_annotation(annotation)
            location = annotation.location
            tokens = tokenize(location.source)
            base = location.start_pos
            skip = Set.new
            before_token_if_lparen(tokens, base, annotation.type) do |b|
              skip << (b.location.start_pos + base)
            end
            annotation.type.each_type do |type|
              check_type(tokens:, type:, base:, skip:)
            end
          end
        end
      end
    end
  end
end
