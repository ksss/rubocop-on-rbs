# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::ClassicType, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () -> NilClass
                       ^^^^^^^^ Use `nil` instead of `NilClass`

        def bar: (TrueClass, ?FalseClass) -> void
                  ^^^^^^^^^ Use `true` instead of `TrueClass`
                              ^^^^^^^^^^ Use `false` instead of `FalseClass`

        def baz: (a: FalseClass, **NilClass) -> void
                     ^^^^^^^^^^ Use `false` instead of `FalseClass`
                                   ^^^^^^^^ Use `nil` instead of `NilClass`

        @ivar: NilClass
               ^^^^^^^^ Use `nil` instead of `NilClass`

        @@cvar: TrueClass
                ^^^^^^^^^ Use `true` instead of `TrueClass`

        self.@civar: FalseClass
                     ^^^^^^^^^^ Use `false` instead of `FalseClass`
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> nil

        def bar: (true, ?false) -> void

        def baz: (a: false, **nil) -> void

        @ivar: nil

        @@cvar: true

        self.@civar: false
      end
    RBS
  end

  it 'replace in complex type' do
    expect_offense(<<~RBS)
      class Foo
        def union: (FalseClass | true) -> (NilClass | TrueClass)
                    ^^^^^^^^^^ Use `false` instead of `FalseClass`
                                           ^^^^^^^^ Use `nil` instead of `NilClass`
                                                      ^^^^^^^^^ Use `true` instead of `TrueClass`
        def intersection: (FalseClass & true) -> void
                           ^^^^^^^^^^ Use `false` instead of `FalseClass`
        def record: ({ a: FalseClass, b: TrueClass }) -> void
                          ^^^^^^^^^^ Use `false` instead of `FalseClass`
                                         ^^^^^^^^^ Use `true` instead of `TrueClass`
        def class_instance: (Foo[FalseClass, TrueClass]) -> void
                                 ^^^^^^^^^^ Use `false` instead of `FalseClass`
                                             ^^^^^^^^^ Use `true` instead of `TrueClass`
        def tuple: ([FalseClass, TrueClass]) -> void
                     ^^^^^^^^^^ Use `false` instead of `FalseClass`
                                 ^^^^^^^^^ Use `true` instead of `TrueClass`
        def optional: (NilClass?) -> void
                       ^^^^^^^^ Use `nil` instead of `NilClass`
        def proc: (^(FalseClass) -> TrueClass) -> NilClass
                     ^^^^^^^^^^ Use `false` instead of `FalseClass`
                                    ^^^^^^^^^ Use `true` instead of `TrueClass`
                                                  ^^^^^^^^ Use `nil` instead of `NilClass`
        def alias: (a[NilClass]) -> void
                      ^^^^^^^^ Use `nil` instead of `NilClass`
        def interface: (_I[FalseClass]) -> void
                           ^^^^^^^^^^ Use `false` instead of `FalseClass`
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def union: (false | true) -> (nil | true)
        def intersection: (false & true) -> void
        def record: ({ a: false, b: true }) -> void
        def class_instance: (Foo[false, true]) -> void
        def tuple: ([false, true]) -> void
        def optional: (nil?) -> void
        def proc: (^(false) -> true) -> nil
        def alias: (a[nil]) -> void
        def interface: (_I[false]) -> void
      end
    RBS
  end
end
