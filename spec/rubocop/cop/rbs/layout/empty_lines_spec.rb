# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::EmptyLines, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () -> void


      ^{} Extra blank line detected.
        def bar: () -> void
      end


      ^{} Extra blank line detected.

      ^{} Extra blank line detected.
      class Bar
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> void

        def bar: () -> void
      end

      class Bar
      end
    RBS
  end
end
