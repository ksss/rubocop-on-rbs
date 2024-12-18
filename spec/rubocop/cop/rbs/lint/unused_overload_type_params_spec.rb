# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::UnusedOverloadTypeParams, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: [T] () -> void
                  ^ Unused overload type variable - `T`.
        def bar: [A, B] (A) -> void
                     ^ Unused overload type variable - `B`.
        def baz: [T < Integer, U < String] () -> T
                               ^ Unused overload type variable - `U`.
      end

      class Bar[A]
        def m: [B] () -> A
                ^ Unused overload type variable - `B`.
      end
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Foo
        def foo: [T] () -> T
        def bar: [T] (Array[T | Integer]) -> void
        def baz: [T] ({a: array[[T]]}) -> void
        def nest: [A < Array[B], B < Integer] (A) -> void
      end
    RBS
  end
end
