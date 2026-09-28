# frozen_string_literal: true

module RuboCop
  module RBS
    # Base class for cops that operate on RBS signatures.
    class CopBase < RuboCop::Cop::Base
      include RuboCop::RBS::CopHelper

      attr_reader :processed_rbs_source #: RuboCop::RBS::ProcessedRBSSource

      exclude_from_registry

      def self.documentation_url(_config = nil)
        base = "cops_#{department.to_s.downcase.tr('/', '_')}"
        fragment = cop_name.downcase.gsub(/[^a-z]/, '')
        "https://github.com/ksss/rubocop-on-rbs/blob/v#{VERSION}/docs/modules/ROOT/pages/#{base}.adoc##{fragment}"
      end

      def on_new_investigation
        # Called here when valid as Ruby
        investigation_rbs()
      end

      def on_other_file
        investigation_rbs()
      end

      # Shared across cops. Keyed by ProcessedSource so an entry dies with its file.
      # WeakKeyMap (not WeakMap) because values must stay alive while the key does.
      CACHE = ObjectSpace::WeakKeyMap.new

      #: () -> void
      def investigation_rbs
        return unless processed_source.buffer.name.then { |n| n.end_with?(".rbs") || n == "(string)" }

        @processed_rbs_source = CACHE[processed_source] ||= RuboCop::RBS::ProcessedRBSSource.new(rbs_buffer)

        if processed_rbs_source.error
          on_rbs_parsing_error()
        else
          on_rbs_new_investigation()

          processed_rbs_source.decls.each do |decl|
            walk(decl)
          end
        end
      end

      #: () -> void
      def on_rbs_new_investigation; end

      #: () -> void
      def on_rbs_parsing_error; end

      # other on_* methods should sync with `#walk` method
      #: (::RBS::AST::Declarations::Class) -> void
      def on_rbs_class(member); end

      #: (::RBS::AST::Declarations::Module) -> void
      def on_rbs_module(member); end

      #: (::RBS::AST::Declarations::Interface) -> void
      def on_rbs_interface(member); end

      #: (::RBS::AST::Declarations::Constant) -> void
      def on_rbs_constant(const); end

      #: (::RBS::AST::Declarations::Global) -> void
      def on_rbs_global(global); end

      #: (::RBS::AST::Declarations::TypeAlias) -> void
      def on_rbs_type_alias(decl); end

      #: (::RBS::AST::Members::MethodDefinition) -> void
      def on_rbs_def(member); end

      #: (::RBS::AST::Members::Attribute) -> void
      def on_rbs_attribute(member); end

      #: (::RBS::AST::Members::Public) -> void
      def on_rbs_public(member); end

      #: (::RBS::AST::Members::Private) -> void
      def on_rbs_private(member); end

      #: (::RBS::AST::Members::Var) -> void
      def on_rbs_var(member); end

      #: (untyped) -> void
      def walk(decl)
        case decl
        when ::RBS::AST::Declarations::Module
          on_rbs_module(decl)
          decl.members.each { |member| walk(member) }
        when ::RBS::AST::Declarations::Class
          on_rbs_class(decl)
          decl.members.each { |member| walk(member) }
        when ::RBS::AST::Declarations::Interface
          on_rbs_interface(decl)
          decl.members.each { |member| walk(member) }
        when ::RBS::AST::Declarations::Constant
          on_rbs_constant(decl)
        when ::RBS::AST::Declarations::Global
          on_rbs_global(decl)
        when ::RBS::AST::Declarations::TypeAlias
          on_rbs_type_alias(decl)
        when ::RBS::AST::Members::MethodDefinition
          on_rbs_def(decl)
        when ::RBS::AST::Members::Attribute
          on_rbs_attribute(decl)
        when ::RBS::AST::Members::Public
          on_rbs_public(decl)
        when ::RBS::AST::Members::Private
          on_rbs_private(decl)
        when ::RBS::AST::Members::Var
          on_rbs_var(decl)
        end
      end

      #: () -> ::RBS::Buffer
      def rbs_buffer
        ::RBS::Buffer.new(
          name: processed_source.buffer.name,
          content: processed_source.raw_source
        )
      end

      private

      # HACK: Required to autocorrect
      def current_corrector
        @current_corrector ||= RuboCop::Cop::Corrector.new(@processed_source) if @processed_rbs_source.valid_syntax?
      end
    end
  end
end
