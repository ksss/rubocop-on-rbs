# frozen_string_literal: true

module RuboCop
  module RBS
    module OnTypeHelper
      #: (Array[Class] types, ::RBS::Types::t type) { (::RBS::Types::t t) -> void } -> void
      def on_type(types, type, &block)
        case type
        when *types
          yield type
        end
        type.each_type do |t|
          on_type(types, t, &block)
        end
      end

      #: (Array[Class] types, ::RBS::Types::t type) { (::RBS::Types::t t) -> void } -> void
      def on_not_type(types, type, &block)
        case type
        when *types
          # not
        else
          yield type
        end
        type.each_type do |t|
          on_not_type(types, t, &block)
        end
      end
    end
  end
end
