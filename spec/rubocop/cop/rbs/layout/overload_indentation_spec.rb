# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::OverloadIndentation, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      # Hello
      class Foo
        def foo: () -> (void) # Comment1
             | () -> void # Comment2
             ^ Indent the `|` to the first `:`
                 | () -> void # Comment3
                 ^ Indent the `|` to the first `:`
        def bar: () -> void | () -> top
                            ^ Insert newline before `|`
        def baz: () -> void |
                            ^ Insert newline before `|`
                 () -> top
        def qux: () -> void
               |
               ^ Remove newline after `|`
                 () -> top
      end
    RBS

    expect_correction(<<~RBS)
      # Hello
      class Foo
        def foo: () -> (void) # Comment1
               | () -> void # Comment2
               | () -> void # Comment3
        def bar: () -> void
               | () -> top
        def baz: () -> void
               | () -> top
        def qux: () -> void
               | () -> top
      end
    RBS
  end
end
