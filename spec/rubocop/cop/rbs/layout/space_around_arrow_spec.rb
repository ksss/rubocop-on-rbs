# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::SpaceAroundArrow, :config do
  it 'registers an offense with no space before arrow' do
    expect_offense(<<~RBS)
      $global: ^()-> void
                  ^^ Use one space before `->`.
      class Foo
        def foo: ()-> void
                   ^^ Use one space before `->`.
        def bar: () { ()-> void }-> void
                        ^^ Use one space before `->`.
                                 ^^ Use one space before `->`.
        def baz: (^() { ()-> void }-> void) -> void
                          ^^ Use one space before `->`.
                                   ^^ Use one space before `->`.
        CONST: ^()-> void
                  ^^ Use one space before `->`.
        type t = ^()-> void
                    ^^ Use one space before `->`.
        attr_reader a: ^()-> void
                          ^^ Use one space before `->`.
        @ivar: ^()-> void
                  ^^ Use one space before `->`.
      end
    RBS

    expect_correction(<<~RBS)
      $global: ^() -> void
      class Foo
        def foo: () -> void
        def bar: () { () -> void } -> void
        def baz: (^() { () -> void } -> void) -> void
        CONST: ^() -> void
        type t = ^() -> void
        attr_reader a: ^() -> void
        @ivar: ^() -> void
      end
    RBS
  end

  it 'registers an offense with no space after arrow' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () ->void
                    ^^ Use one space after `->`.
        def bar: () { () ->void } ->void
                         ^^ Use one space after `->`.
                                  ^^ Use one space after `->`.
        def baz: (^() { () ->void } ->void) -> void
                           ^^ Use one space after `->`.
                                    ^^ Use one space after `->`.
        def arrow: ->void
                   ^^ Use one space after `->`.
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> void
        def bar: () { () -> void } -> void
        def baz: (^() { () -> void } -> void) -> void
        def arrow: -> void
      end
    RBS
  end

  it 'registers an offense with no space around arrow' do
    expect_offense(<<~RBS)
      class Foo
        def foo: ()->void
                   ^^ Use one space before `->`.
        def bar: () { ()->void }->void
                        ^^ Use one space before `->`.
                                ^^ Use one space before `->`.
        def baz: (^() { ()->void }->void) -> void
                          ^^ Use one space before `->`.
                                  ^^ Use one space before `->`.
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> void
        def bar: () { () -> void } -> void
        def baz: (^() { () -> void } -> void) -> void
      end
    RBS
  end

  it 'registers an offense with long space around arrow' do
    expect_offense(<<~RBS)
      class Foo
        def foo: ()   ->   void
                      ^^ Use one space before `->`.
        def bar: () { ()   ->   void }   ->   void
                           ^^ Use one space before `->`.
                                         ^^ Use one space before `->`.
        def baz: (^() { ()   ->   void }   ->   void) -> void
                             ^^ Use one space before `->`.
                                           ^^ Use one space before `->`.
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> void
        def bar: () { () -> void } -> void
        def baz: (^() { () -> void } -> void) -> void
      end
    RBS
  end
end
