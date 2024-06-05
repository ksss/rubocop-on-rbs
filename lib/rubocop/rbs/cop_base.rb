# frozen_string_literal: true

module RuboCop
  module RBS
    # Base class for cops that operate on RBS signatures.
    class CopBase < RuboCop::Cop::Base
      include RuboCop::Cop::RangeHelp

      attr_reader :processed_rbs_source

      exclude_from_registry

      def on_new_investigation
        # Called here when valid as Ruby
        investigation_rbs()
      end

      def on_other_file
        investigation_rbs()
      end

      def investigation_rbs
        return unless processed_source.buffer.name.then { |n| n.end_with?(".rbs") || n == "(string)" }

        buffer = rbs_buffer()
        @processed_rbs_source = RuboCop::RBS::ProcessedRBSSource.new(buffer)

        if processed_rbs_source.error
          on_rbs_parsing_error()
        else
          # HACK: Autocorrector needs to clear diagnostics
          processed_source.diagnostics.clear

          on_rbs_new_investigation()

          processed_rbs_source.decls.each do |decl|
            walk(decl)
          end
        end
      end

      def on_rbs_new_investigation; end
      def on_rbs_parsing_error; end

      # other on_* methods should sync with `#walk` method
      def on_rbs_class(member); end
      def on_rbs_module(member); end
      def on_rbs_interface(member); end
      def on_rbs_constant(const); end
      def on_rbs_global(global); end
      def on_rbs_type_alias(decl); end
      def on_rbs_def(member); end
      def on_rbs_attribute(member); end

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
        end
      end

      def rbs_buffer
        ::RBS::Buffer.new(
          name: processed_source.buffer.name,
          content: processed_source.raw_source
        )
      end

      def location_to_range(location)
        range_between(location.start_pos, location.end_pos)
      end
    end
  end
end
