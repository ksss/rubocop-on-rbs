# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::EmptyLinesAroundClassBody, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo

      ^{} Extra empty line detected at class body beginning.
        # Comment
        def foo: () -> void

        class Bar

      ^{} Extra empty line detected at class body beginning.
        end

      ^{} Extra empty line detected at class body end.
      end

      class Bar

      ^{} Extra empty line detected at class body beginning.
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        # Comment
        def foo: () -> void

        class Bar
        end
      end

      class Bar
      end
    RBS
  end

  it 'does not register an offense when one line source' do
    expect_no_offenses(<<~RBS)
      class Foo end
    RBS
  end

  it 'does not register an offense when module' do
    expect_no_offenses(<<~RBS)
      module Foo

        def foo: () -> void

      end
    RBS
  end

  it 'does not register an offense with one line class' do
    expect_no_offenses(<<~RBS)
      class Foo
      end

      class Bar end
    RBS
  end
end
