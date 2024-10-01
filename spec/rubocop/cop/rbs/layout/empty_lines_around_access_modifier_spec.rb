# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::EmptyLinesAroundAccessModifier, :config do
  it 'requires blank line before private' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () -> void
        private
        ^^^^^^^ Keep a blank line before and after `<private>`.

        def bar: () -> void
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> void

        private

        def bar: () -> void
      end
    RBS
  end

  it 'requires blank line after private with class' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () -> void

        private
        ^^^^^^^ Keep a blank line before and after `<private>`.
        def bar: () -> void
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> void

        private

        def bar: () -> void
      end
    RBS
  end

  it 'requires blank line after private with module' do
    expect_offense(<<~RBS)
      module Foo
        def foo: () -> void

        private
        ^^^^^^^ Keep a blank line before and after `<private>`.
        def bar: () -> void
      end
    RBS

    expect_correction(<<~RBS)
      module Foo
        def foo: () -> void

        private

        def bar: () -> void
      end
    RBS
  end

  it 'accepts missing blank line when at the beginning of class' do
    expect_no_offenses(<<~RBS)
      class Test
        private
      end
    RBS

    expect_no_offenses(<<~RBS)
      class Test
        private

        def test: () -> void
      end
    RBS
  end

  it 'accepts missing blank line when at the beginning of module' do
    expect_no_offenses(<<~RBS)
      module Test
        private

        def test: () -> void
      end
    RBS
  end

  it 'accepts missing blank line when at the beginning of interface' do
    expect_no_offenses(<<~RBS)
      interface _Test
        private

        def test: () -> void
      end
    RBS
  end
end
