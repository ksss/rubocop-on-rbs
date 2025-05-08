# frozen_string_literal: true

module RuboCop
  module RBS
    # @example
    #   include RuboCop::RBS::RBSInlineHooks
    #   def on_rbs_inline_def(member)
    #     p member
    #   end
    module RBSInlineHooks
      def investigation_rbs_inline
        if processed_source.buffer.name.then { |n| n.end_with?(".rb") || n == "(string)" }
          processed_rbs_inline.result.declarations.each do |decl|
            case_ruby_decl(decl)
          end
        end
      end

      def case_ruby_decl(decl)
        case decl
        when ::RBS::AST::Ruby::Members::Base
          case_ruby_member(decl)
        when ::RBS::AST::Ruby::Declarations::ModuleDecl
          on_rbs_inline_module(decl)
          decl.members.each { |member| case_ruby_decl(member) }
        when ::RBS::AST::Ruby::Declarations::ClassDecl
          on_rbs_inline_class(decl)
          decl.members.each { |member| case_ruby_decl(member) }
        end
      end

      def case_ruby_member(member)
        case member
        when ::RBS::AST::Ruby::Members::DefMember
          on_rbs_inline_def(member)
        end
      end

      def on_rbs_inline_class(decl); end
      def on_rbs_inline_module(decl); end
      def on_rbs_inline_def(member); end
    end
  end
end
