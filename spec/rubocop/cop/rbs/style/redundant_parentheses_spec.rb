# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::RedundantParentheses, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: ( ( Integer ) | ( String ) ) -> void
                   ^^^^^^^^^^^ Don't use parentheses around simple type.
                                 ^^^^^^^^^^ Don't use parentheses around simple type.
        def bar: () -> (Integer)
                       ^^^^^^^^^ Don't use parentheses around simple type.
        def proc: (^((bool)) -> void) -> (void)
                     ^^^^^^ Don't use parentheses around simple type.
                                         ^^^^^^ Don't use parentheses around simple type.
        def optional: () -> ((1 | 2)?)
                            ^^^^^^^^^^ Don't use parentheses around simple type.
        attr_reader a: (bool)
                       ^^^^^^ Don't use parentheses around simple type.
      end
      CONST: ^((bool)) { ((top)) -> (top) } -> (top)
               ^^^^^^ Don't use parentheses around simple type.
                          ^^^^^ Don't use parentheses around simple type.
                                    ^^^^^ Don't use parentheses around simple type.
                                               ^^^^^ Don't use parentheses around simple type.
      $global: (bool)
               ^^^^^^ Don't use parentheses around simple type.
      type a = (bool)
               ^^^^^^ Don't use parentheses around simple type.
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: (  Integer  |  String  ) -> void
        def bar: () -> Integer
        def proc: (^(bool) -> void) -> void
        def optional: () -> (1 | 2)?
        attr_reader a: bool
      end
      CONST: ^(bool) { (top) -> top } -> top
      $global: bool
      type a = bool
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Foo
        def foo: () -> (1 | 2)
        def bar: ((1 | 2)) -> void
        def block: () { (bool) -> void } -> void
        def proc: (^(bool) -> void) -> void
        def param: [T] (^(T) { (T) -> void } -> T, ^(T) -> T) { (T) -> T } -> (^(T) -> T)
      end
    RBS
  end
end
