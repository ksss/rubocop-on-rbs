# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::SpaceAroundBraces, :config do
  it 'registers an offense with no space before brace' do
    expect_offense(<<~RBS)
      class Foo
        def foo: ({a: top}){ ({b: top}) -> {c: top}} -> ^({d: top}){ ({e: top}) -> {f: top}} -> {g: top}
                           ^ Use one space before `{`.
                                                   ^ Use one space before `}`.
                                                                   ^ Use one space before `{`.
                                                                                           ^ Use one space before `}`.
        def bar:{ -> void   } -> void
                ^ Use one space before `{`.
                            ^ Use one space before `}`.
        def foo?: () ?{ () -> void } -> void
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: ({a: top}) { ({b: top}) -> {c: top} } -> ^({d: top}) { ({e: top}) -> {f: top} } -> {g: top}
        def bar: { -> void } -> void
        def foo?: () ?{ () -> void } -> void
      end
    RBS
  end

  it 'registers an offense with no space after brace' do
    expect_offense(<<~RBS)
      class Foo
        def foo: ({a: top}) {({b: top}) -> {c: top} }-> ^({d: top}) {({e: top}) -> {f: top} }-> {g: top}
                            ^ Use one space after `{`.
                                                    ^ Use one space after `}`.
                                                                    ^ Use one space after `{`.
                                                                                            ^ Use one space after `}`.
        def bar: {-> void }   -> void
                 ^ Use one space after `{`.
                          ^ Use one space after `}`.
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: ({a: top}) { ({b: top}) -> {c: top} } -> ^({d: top}) { ({e: top}) -> {f: top} } -> {g: top}
        def bar: { -> void } -> void
      end
    RBS
  end

  it 'registers an offense with no space around left brace' do
    expect_offense(<<~RBS)
      class Foo
        def foo: ({a: top}){({b: top}) -> {c: top}}-> ^({d: top}){({e: top}) -> {f: top}}-> {g: top}
                           ^ Use one space before `{`.
                                                  ^ Use one space before `}`.
                                                                 ^ Use one space before `{`.
                                                                                        ^ Use one space before `}`.
        def bar:{-> void   }-> void
                ^ Use one space before `{`.
                           ^ Use one space before `}`.
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: ({a: top}) { ({b: top}) -> {c: top} } -> ^({d: top}) { ({e: top}) -> {f: top} } -> {g: top}
        def bar: { -> void } -> void
      end
    RBS
  end
end
