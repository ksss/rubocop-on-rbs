# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::TrueFalse, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () -> (true | true | false)
                        ^^^^^^^^^^^^^^^^^^^ Use `bool` instead of `true | true | false`
        def tuple: () -> [true | false]
                          ^^^^^^^^^^^^ Use `bool` instead of `true | false`
        def record: ({ a: true | false }) -> void
                          ^^^^^^^^^^^^ Use `bool` instead of `true | false`
        def args: () -> A[true | false]
                          ^^^^^^^^^^^^ Use `bool` instead of `true | false`
        def interface: () -> _I[true | false]
                                ^^^^^^^^^^^^ Use `bool` instead of `true | false`
        def proc: () -> ^(true | false) -> void
                          ^^^^^^^^^^^^ Use `bool` instead of `true | false`
        def intersection: (Integer & (true | false)) -> void
                                      ^^^^^^^^^^^^ Use `bool` instead of `true | false`

        def self.bar: (TrueClass | FalseClass) -> void
                       ^^^^^^^^^^^^^^^^^^^^^^ Use `bool` instead of `TrueClass | FalseClass`
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> (bool)
        def tuple: () -> [bool]
        def record: ({ a: bool }) -> void
        def args: () -> A[bool]
        def interface: () -> _I[bool]
        def proc: () -> ^(bool) -> void
        def intersection: (Integer & (bool)) -> void

        def self.bar: (bool) -> void
      end
    RBS
  end

  it 'should registers an offense in optional type' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () -> (true | false)?
                        ^^^^^^^^^^^^ Use `bool` instead of `true | false`

        def self.bar: (Integer | TrueClass | nil | FalseClass) -> void
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `Integer | bool | nil` instead of `Integer | TrueClass | nil | FalseClass`
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> (bool)?

        def self.bar: (Integer | bool | nil) -> void
      end
    RBS
  end
end
