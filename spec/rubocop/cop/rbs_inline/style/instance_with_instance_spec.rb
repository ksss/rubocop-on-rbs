# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Style::InstanceWithInstance, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs @ivar: instance
                      ^^^^^^^^ Use `self` instead of `instance`.

        #: (instance) -> instance
            ^^^^^^^^ Use `self` instead of `instance`.
                         ^^^^^^^^ Use `self` instead of `instance`.
        def foo(x)
        end

        # @rbs x: instance | instance
                  ^^^^^^^^ Use `self` instead of `instance`.
                             ^^^^^^^^ Use `self` instead of `instance`.
        def bar(x)
        end

        #: () -> instance
        def self.foo
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        # @rbs @ivar: self

        #: (self) -> self
        def foo(x)
        end

        # @rbs x: self | self
        def bar(x)
        end

        #: () -> instance
        def self.foo
        end
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      module Foo
        #: () -> instance
        def foo
        end

      end

      class Bar
        module Foo
          #: () -> instance
          def foo
          end
        end
      end
    RUBY
  end
end
