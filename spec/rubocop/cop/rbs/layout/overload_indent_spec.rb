# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::OverloadIndentation, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      # Hello
      class Foo
        def foo: () -> (void) # Comment1
             | () -> void # Comment2
      ^^^^^^^ Indent the `|` to the first `:`
                 | () -> void # Comment3
      ^^^^^^^^^^^ Indent the `|` to the first `:`
      end
    RBS

    expect_correction(<<~RBS)
      # Hello
      class Foo
        def foo: () -> (void) # Comment1
               | () -> void # Comment2
               | () -> void # Comment3
      end
    RBS
  end

  it 'should not format if one line' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () -> void | () -> void
                            | () -> void
      ^^^^^^^^^^^^^^^^^^^^^^ Indent the `|` to the first `:`
      end
    RBS
  end
end
