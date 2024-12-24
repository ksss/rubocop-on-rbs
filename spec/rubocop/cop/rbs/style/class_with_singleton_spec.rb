# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::ClassWithSingleton, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def self.foo: (class) -> class
                       ^^^^^ Use `self` instead of `class`.
                                 ^^^^^ Use `self` instead of `class`.

        def self.bar: [T] () { () [self: class] -> void } -> T
                                         ^^^^^ Use `self` instead of `class`.

        def foo: () -> class

        def self?.foo: () -> class

        @ivar: class

        @@cvar: class

        self.@civar: class
      end

      module Foo
        def self.foo: () -> class
                            ^^^^^ Use `self` instead of `class`.
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def self.foo: (self) -> self

        def self.bar: [T] () { () [self: self] -> void } -> T

        def foo: () -> class

        def self?.foo: () -> class

        @ivar: class

        @@cvar: class

        self.@civar: class
      end

      module Foo
        def self.foo: () -> self
      end
    RBS
  end

  it 'registers an offense on generic class' do
    expect_offense(<<~RBS)
      class Bar[T]
        def self.foo: (class) -> class
                       ^^^^^ Use `self` instead of `class`.
                                 ^^^^^ Use `self` instead of `class`.
      end
    RBS

    expect_correction(<<~RBS)
      class Bar[T]
        def self.foo: (self) -> self
      end
    RBS
  end
end
