# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::AmbiguousKeywordArgumentKey, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: (::Integer, ?String, aaa?: Integer, ?bbb?: String) -> void
                                      ^^^^ `aaa?` is not local variable name. Did you mean `?aaa` for optional keyword argument?
                                                      ^^^^ `bbb?` is not local variable name. Did you mean `?bbb` for optional keyword argument?

        def bar: (::Integer, ?String, aaa!: Integer, ?bbb!: String) -> void
                                      ^^^^ `aaa!` is not local variable name.
                                                      ^^^^ `bbb!` is not local variable name.

        def baz: (::Integer, ?String, Aaa: Integer, ?Bbb: String) -> void
                                      ^^^ `Aaa` is not local variable name.
                                                     ^^^ `Bbb` is not local variable name.
      end
    RBS
  end
end
