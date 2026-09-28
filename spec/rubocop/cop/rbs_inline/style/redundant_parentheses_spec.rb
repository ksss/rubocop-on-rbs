# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Style::RedundantParentheses, :config do
  it 'registers an offense for colon style' do
    expect_offense(<<~RUBY)
      class Foo
        #: () -> (bool)
                 ^^^^^^ Don't use parentheses around simple type.
        def foo
        end

        #: ((Integer)) { ((String)) -> (void) } -> void
            ^^^^^^^^^ Don't use parentheses around simple type.
                          ^^^^^^^^ Don't use parentheses around simple type.
                                       ^^^^^^ Don't use parentheses around simple type.
        def baz(x)
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        #: () -> bool
        def foo
        end

        #: (Integer) { (String) -> void } -> void
        def baz(x)
        end
      end
    RUBY
  end

  it 'registers an offense for doc style' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs @ivar: (Integer)
                      ^^^^^^^^^ Don't use parentheses around simple type.

        # @rbs x: (Integer)
                  ^^^^^^^^^ Don't use parentheses around simple type.
        # @rbs *rest: (String)
                      ^^^^^^^^ Don't use parentheses around simple type.
        # @rbs k: (Symbol)
                  ^^^^^^^^ Don't use parentheses around simple type.
        # @rbs **opts: (untyped)
                       ^^^^^^^^^ Don't use parentheses around simple type.
        # @rbs &block: ((Integer)) -> (void)
                        ^^^^^^^^^ Don't use parentheses around simple type.
                                      ^^^^^^ Don't use parentheses around simple type.
        # @rbs return: (bool)
                       ^^^^^^ Don't use parentheses around simple type.
        def foo(x, *rest, k:, **opts, &block)
        end

        # @rbs x: (Integer)
                  ^^^^^^^^^ Don't use parentheses around simple type.
        def bar(x) #: (String)
                      ^^^^^^^^ Don't use parentheses around simple type.
        end

        attr_reader :attr #: (Integer)
                             ^^^^^^^^^ Don't use parentheses around simple type.

        CONST = 1 #: (Integer)
                     ^^^^^^^^^ Don't use parentheses around simple type.
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        # @rbs @ivar: Integer

        # @rbs x: Integer
        # @rbs *rest: String
        # @rbs k: Symbol
        # @rbs **opts: untyped
        # @rbs &block: (Integer) -> void
        # @rbs return: bool
        def foo(x, *rest, k:, **opts, &block)
        end

        # @rbs x: Integer
        def bar(x) #: String
        end

        attr_reader :attr #: Integer

        CONST = 1 #: Integer
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        #: ((true | false)) -> bool
        def foo(x)
        end

        # @rbs x: (Integer | String)
        # @rbs &block: (Integer) -> void
        def bar(x, &block)
        end

        CONST = 1
      end
    RUBY
  end
end
