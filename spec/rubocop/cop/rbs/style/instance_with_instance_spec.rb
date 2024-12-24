# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::InstanceWithInstance, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: (instance) -> instance
                  ^^^^^^^^ Use `self` instead of `instance`.
                               ^^^^^^^^ Use `self` instead of `instance`.

        def bar: [T] () { () [self: instance] -> void } -> T
                                    ^^^^^^^^ Use `self` instead of `instance`.

        def self.foo: () -> instance

        def self?.foo: () -> instance

        @ivar: instance
               ^^^^^^^^ Use `self` instead of `instance`.

        @@cvar: instance

        self.@civar: instance
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: (self) -> self

        def bar: [T] () { () [self: self] -> void } -> T

        def self.foo: () -> instance

        def self?.foo: () -> instance

        @ivar: self

        @@cvar: instance

        self.@civar: instance
      end
    RBS
  end

  it 'registers an offense on inherited generic class' do
    expect_offense(<<~RBS)
      class Bar < Foo[Integer]
        def foo: (instance) -> instance
                  ^^^^^^^^ Use `self` instead of `instance`.
                               ^^^^^^^^ Use `self` instead of `instance`.
      end
    RBS

    expect_correction(<<~RBS)
      class Bar < Foo[Integer]
        def foo: (self) -> self
      end
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Generic[T]
        def a: () -> instance
      end
    RBS

    expect_no_offenses(<<~RBS)
      module Foo
        def foo: () -> instance

        @ivar: instance
      end

      class Bar
        module Foo
          def foo: () -> instance
        end
      end
    RBS

    expect_no_offenses(<<~RBS)
      interface _Foo
        def foo: () -> instance
      end
    RBS
  end
end
