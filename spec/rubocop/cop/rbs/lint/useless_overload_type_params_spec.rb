# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::UselessOverloadTypeParams, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: [T] () -> void
                  ^ Useless overload type variable - `T`.
        def bar: [A, B] (A) -> void
                     ^ Useless overload type variable - `B`.
      end
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Foo
        def foo: () -> void
        def bar: [T] (Array[T | Integer]) -> Array[T | Integer]
        def baz: [T,U] (array[T]) -> {a: [_I[U]]}
      end
    RBS
  end
end
