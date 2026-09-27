# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Style::BlockReturnBoolish, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        #: () { () -> bool } -> void
                      ^^^^ Use `boolish` instead of `bool` in block return type.
        def foo
        end

        # @rbs &block: () -> bool
                             ^^^^ Use `boolish` instead of `bool` in block return type.
        def bar(&block)
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        #: () { () -> boolish } -> void
        def foo
        end

        # @rbs &block: () -> boolish
        def bar(&block)
        end
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        #: () { () -> boolish } -> bool
        def foo
        end
      end
    RUBY
  end
end
