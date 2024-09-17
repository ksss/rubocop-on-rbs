# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::EmptyLinesAroundModuleBody, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      module Foo

      ^{} Extra empty line detected at module body beginning.
        # Comment
        def foo: () -> void

      ^{} Extra empty line detected at module body end.
      end

      module Bar

      ^{} Extra empty line detected at module body beginning.
      end
    RBS

    expect_correction(<<~RBS)
      module Foo
        # Comment
        def foo: () -> void
      end

      module Bar
      end
    RBS
  end

  it 'does not register an offense when class' do
    expect_no_offenses(<<~RBS)
      class Foo

        def foo: () -> void

      end
    RBS
  end
end
