# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::TrueFalse, :config do
  it 'registers an offense on ruby' do
    expect_offense(<<~RBS, "a.rb")
      class Foo
        # Comment
        # @rbs return: true | false
                       ^^^^^^^^^^^^ Use `bool` instead of `true | false`
        def foo
        end
      end
    RBS

    expect_offense(<<~RUBY, "a.rb")
      class Foo
        def foo #: true | false
                   ^^^^^^^^^^^^ Use `bool` instead of `true | false`
        end
      end
    RUBY
  end

  it 'registers an offense' do
    expect_offense(<<~RBS, "a.rbs")
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

        CONST: true | false
               ^^^^^^^^^^^^ Use `bool` instead of `true | false`

        type t = TrueClass | FalseClass
                 ^^^^^^^^^^^^^^^^^^^^^^ Use `bool` instead of `TrueClass | FalseClass`

        attr_accessor a: true | FalseClass
                         ^^^^^^^^^^^^^^^^^ Use `bool` instead of `true | FalseClass`

        @var: TrueClass | false
              ^^^^^^^^^^^^^^^^^ Use `bool` instead of `TrueClass | false`
      end

      $global: true | false
               ^^^^^^^^^^^^ Use `bool` instead of `true | false`
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

        CONST: bool

        type t = bool

        attr_accessor a: bool

        @var: bool
      end

      $global: bool
    RBS
  end

  it 'should registers an offense in optional type' do
    expect_offense(<<~RBS, "a.rbs")
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
