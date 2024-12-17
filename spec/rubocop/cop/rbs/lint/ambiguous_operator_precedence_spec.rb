# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::AmbiguousOperatorPrecedence, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: (A | B & C) -> void
                      ^^^^^ Wrap expressions with varying precedence with parentheses to avoid ambiguity.
        def bar: (A & B | C) -> void
                  ^^^^^ Wrap expressions with varying precedence with parentheses to avoid ambiguity.
        @a: (A | B & C)
                 ^^^^^ Wrap expressions with varying precedence with parentheses to avoid ambiguity.
      end
      CONST: (A | B & C?)
                  ^^^^^^ Wrap expressions with varying precedence with parentheses to avoid ambiguity.
      $global: A & B | C & D
               ^^^^^ Wrap expressions with varying precedence with parentheses to avoid ambiguity.
                       ^^^^^ Wrap expressions with varying precedence with parentheses to avoid ambiguity.
      type a = A | B & C | D
                   ^^^^^ Wrap expressions with varying precedence with parentheses to avoid ambiguity.
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: (A | (B & C)) -> void
        def bar: ((A & B) | C) -> void
        @a: (A | (B & C))
      end
      CONST: (A | (B & C?))
      $global: (A & B) | (C & D)
      type a = A | (B & C) | D
    RBS
  end
end
