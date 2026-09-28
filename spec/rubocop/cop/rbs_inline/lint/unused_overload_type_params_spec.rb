# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Lint::UnusedOverloadTypeParams, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        #: [T] () -> void
            ^ Unused overload type variable - `T`.
        def foo
        end

        # @rbs [T, U] (T) -> void
                   ^ Unused overload type variable - `U`.
        def bar(x)
        end
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        #: [T] (T) -> T
        def foo(x)
        end

        #: [T, U < Array[T]] (U) -> void
        def bar(x)
        end
      end
    RUBY
  end
end
