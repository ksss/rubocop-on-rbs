# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::MergeUntyped, :config do
  it 'should check duplicated type' do
    expect_offense(<<~RBS)
      class Foo
        def foo: (Integer | Integer) -> void
                  ^^^^^^^^^^^^^^^^^ Use `Integer` instead of `Integer | Integer`

        def bar: () -> (Integer & String & Integer)
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `Integer & String` instead of `Integer & String & Integer`

        def baz: () -> ((Integer | Integer)?)?
                                           ^ Remove `?` in Optional
                         ^^^^^^^^^^^^^^^^^ Use `Integer` instead of `Integer | Integer`

        def qux: () -> (((Integer?)? | Integer)?)?
                                 ^ Remove `?` in Optional
                                               ^ Remove `?` in Optional
       end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: (Integer) -> void

        def bar: () -> (Integer & String)

        def baz: () -> ((Integer))?

        def qux: () -> (((Integer)? | Integer))?
       end
    RBS
  end

  it 'should check untyped, void, top, bottom' do
    expect_offense(<<~RBS)
      class Foo
        def foo: (untyped?) -> void?
                  ^^^^^^^^ Use `untyped` instead of `untyped?`
                               ^^^^^ Use `void` instead of `void?`

        def bar: (top? | bot?) -> (bot? | top?)
                  ^^^^ Use `top` instead of `top?`
                         ^^^^ Use `bot` instead of `bot?`
                                   ^^^^ Use `bot` instead of `bot?`
                                          ^^^^ Use `top` instead of `top?`

        def baz: () -> (top? | bot?)?
                        ^^^^ Use `top` instead of `top?`
                               ^^^^ Use `bot` instead of `bot?`
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: (untyped) -> void

        def bar: (top | bot) -> (bot | top)

        def baz: () -> (top | bot)?
      end
    RBS
  end
end
