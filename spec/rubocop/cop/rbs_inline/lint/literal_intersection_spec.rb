# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Lint::LiteralIntersection, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs @var: (1 & _Foo) & _Bar
                      ^ Don't use literals with `&`.

        #: (1 & 2) -> void
                ^ Don't use literals with `&`.
            ^ Don't use literals with `&`.
        def foo(x)
        end

        # @rbs x: 1 & _Foo
                  ^ Don't use literals with `&`.
        def bar(x)
        end

        attr_reader :a #: 1 & _Foo
                          ^ Don't use literals with `&`.

        CONST = 1 #: 1 & _Foo
                     ^ Don't use literals with `&`.
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        #: (_Foo & _Bar) -> void
        def foo(x)
        end

        CONST = 1
      end
    RUBY
  end
end
