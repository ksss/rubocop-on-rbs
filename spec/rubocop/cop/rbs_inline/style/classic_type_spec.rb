# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Style::ClassicType, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs @ivar: TrueClass
                      ^^^^^^^^^ Use `true` instead of `TrueClass`

        # @rbs x: TrueClass
                  ^^^^^^^^^ Use `true` instead of `TrueClass`
        # @rbs return: NilClass
                       ^^^^^^^^ Use `nil` instead of `NilClass`
        def foo(x)
        end

        def bar #: FalseClass
                   ^^^^^^^^^^ Use `false` instead of `FalseClass`
        end

        attr_reader :baz #: Array[NilClass]
                                  ^^^^^^^^ Use `nil` instead of `NilClass`

        CONST = nil #: NilClass
                       ^^^^^^^^ Use `nil` instead of `NilClass`
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        # @rbs @ivar: true

        # @rbs x: true
        # @rbs return: nil
        def foo(x)
        end

        def bar #: false
        end

        attr_reader :baz #: Array[nil]

        CONST = nil #: nil
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        #: (true) -> nil
        def foo(x)
        end

        CONST = nil
        attr_reader :bar
      end
    RUBY
  end
end
