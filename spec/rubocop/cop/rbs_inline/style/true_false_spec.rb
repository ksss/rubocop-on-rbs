# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Style::TrueFalse, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs @ivar: true | false
                      ^^^^^^^^^^^^ Use `bool` instead of `true | false`

        #: (true | false) -> (true | false)
            ^^^^^^^^^^^^ Use `bool` instead of `true | false`
                              ^^^^^^^^^^^^ Use `bool` instead of `true | false`
        def foo(x)
        end

        # @rbs x: TrueClass | FalseClass
                  ^^^^^^^^^^^^^^^^^^^^^^ Use `bool` instead of `TrueClass | FalseClass`
        def bar(x)
        end

        attr_reader :baz #: true | nil | false
                            ^^^^^^^^^^^^^^^^^^ Use `bool | nil` instead of `true | nil | false`

        CONST = true #: true | false
                        ^^^^^^^^^^^^ Use `bool` instead of `true | false`
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        # @rbs @ivar: bool

        #: (bool) -> (bool)
        def foo(x)
        end

        # @rbs x: bool
        def bar(x)
        end

        attr_reader :baz #: bool | nil

        CONST = true #: bool
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        #: (bool) -> bool
        def foo(x)
        end

        CONST = true
      end
    RUBY
  end
end
