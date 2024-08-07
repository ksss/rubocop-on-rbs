# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::TrailingWhitespace, :config do
  let(:trailing_whitespace) { ' ' }

  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo#{trailing_whitespace}
               ^ Trailing whitespace detected.
        def foo: () -> void#{trailing_whitespace * 2}
                           ^^ Trailing whitespace detected.
      #{trailing_whitespace * 3}
      ^^^ Trailing whitespace detected.
        def bar: () -> void
      end#{trailing_whitespace * 4}
         ^^^^ Trailing whitespace detected.
    RBS
    expect_correction(<<~RBS)
      class Foo
        def foo: () -> void

        def bar: () -> void
      end
    RBS
  end

  it 'registers an offense with multi byte characters' do
    expect_offense(<<~RBS)
      class Foo
        HOGE: {
          '1' => 'あいう'
        }
                              #{''}
      ^^^^^^^^^^^^^^^^^^^^^^^^ Trailing whitespace detected.
      end
    RBS
    expect_correction(<<~RBS)
      class Foo
        HOGE: {
          '1' => 'あいう'
        }

      end
    RBS
  end
end
