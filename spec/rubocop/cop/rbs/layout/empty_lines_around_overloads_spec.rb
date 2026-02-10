# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::EmptyLinesAroundOverloads, :config do
  it 'should registers an offense when simple case' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () -> void

      ^{} Empty line detected around overloads.

      ^{} Empty line detected around overloads.

      ^{} Empty line detected around overloads.
               | () -> void

        def bar: () -> void

      ^{} Empty line detected around overloads.
               # () -> void

      ^{} Empty line detected around overloads.
               | () -> void

        def baz: () -> void

      ^{} Empty line detected around overloads.
               | () -> void

      ^{} Empty line detected around overloads.
               | ...

        def overload: ...
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> void
               | () -> void

        def bar: () -> void
               # () -> void
               | () -> void

        def baz: () -> void
               | () -> void
               | ...

        def overload: ...
      end
    RBS
  end
end
