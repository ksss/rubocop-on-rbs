# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::SpaceBeforeOverload, :config do
  it 'registers an offense with no space around colon' do
    expect_offense(<<~RBS)
      class Foo
        def foo:() -> ::Time
               ^ Use one space before overload.
               |  () -> ::Time
               ^ Use one space before overload.

        def bar:() -> ::Time
               ^ Use one space before overload.
               |  () -> ::Time
               ^ Use one space before overload.

        def baz:[T] (T) -> T
               ^ Use one space before overload.

        def qux: () -> void
               | [T] (T) -> T

        def overload:...
                    ^ Use one space before overload.

        def overload2: () -> void
                     |  ...
                     ^ Use one space before overload.
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> ::Time
               | () -> ::Time

        def bar: () -> ::Time
               | () -> ::Time

        def baz: [T] (T) -> T

        def qux: () -> void
               | [T] (T) -> T

        def overload: ...

        def overload2: () -> void
                     | ...
      end
    RBS
  end
end
