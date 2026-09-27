# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Style::DuplicatedType, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs @ivar: Symbol | Symbol
                               ^^^^^^ Duplicated type `Symbol`.

        # @rbs x: Integer | Integer
                            ^^^^^^^ Duplicated type `Integer`.
        def foo(x)
        end

        #: (Integer & Integer) -> void
                      ^^^^^^^ Duplicated type `Integer`.
        def bar(x)
        end

        attr_reader :baz #: String | String
                                     ^^^^^^ Duplicated type `String`.

        CONST = 1 #: Integer | Integer
                               ^^^^^^^ Duplicated type `Integer`.
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        # @rbs x: Integer | String
        def foo(x)
        end
      end
    RUBY
  end
end
