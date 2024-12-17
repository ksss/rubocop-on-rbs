# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::LiteralIntersection, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: (1 & String & 2) -> void
                  ^ Don't use literals with `&`.
                               ^ Don't use literals with `&`.
        attr_reader a: ^() -> (1 & Bar)
                               ^ Don't use literals with `&`.
        @a: 1 & Bar
            ^ Don't use literals with `&`.
      end
      CONST: "a" & top
             ^^^ Don't use literals with `&`.
      $global: :foo & :bar
               ^^^^ Don't use literals with `&`.
                      ^^^^ Don't use literals with `&`.
      type a = true & false
               ^^^^ Don't use literals with `&`.
                      ^^^^^ Don't use literals with `&`.
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Foo
        def foo: (1) -> void
      end
    RBS
  end
end
