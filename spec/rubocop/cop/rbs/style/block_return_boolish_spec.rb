# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::BlockReturnBoolish, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () { () -> bool } -> void
                            ^^^^ Use `boolish` instead of `bool` in block return type.
        def bar: () { () -> boolish } -> void
        def baz: () { () -> true } -> void
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () { () -> boolish } -> void
        def bar: () { () -> boolish } -> void
        def baz: () { () -> true } -> void
      end
    RBS
  end
end
