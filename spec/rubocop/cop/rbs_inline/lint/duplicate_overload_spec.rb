# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Lint::DuplicateOverload, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        #: () -> void
        #: () -> top
           ^^^^^^^^^ Duplicate overload arguments detected.
        def foo
        end

        # @rbs (Integer) -> void
        #    | (Integer) -> top
               ^^^^^^^^^^^^^^^^ Duplicate overload arguments detected.
        def bar(x)
        end
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        #: () -> void
        #: (Integer) -> void
        def foo(x = nil)
        end

        # @rbs x: Integer
        def bar(x)
        end
      end
    RUBY
  end
end
