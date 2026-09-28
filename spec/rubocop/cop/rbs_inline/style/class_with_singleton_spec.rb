# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Style::ClassWithSingleton, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        #: (class) -> class
            ^^^^^ Use `self` instead of `class`.
                      ^^^^^ Use `self` instead of `class`.
        def self.foo(x)
        end

        # @rbs x: class
                  ^^^^^ Use `self` instead of `class`.
        def self.bar(x)
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        #: (self) -> self
        def self.foo(x)
        end

        # @rbs x: self
        def self.bar(x)
        end
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        #: (class) -> class
        def foo(x)
        end

        #: (self) -> self
        def self.bar(x)
        end
      end
    RUBY
  end
end
