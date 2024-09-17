# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::EmptyLinesAroundInterfaceBody, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      interface _Foo

      ^{} Extra empty line detected at interface body beginning.
        # Comment
        def foo: () -> void

      ^{} Extra empty line detected at interface body end.
      end

      interface _Bar

      ^{} Extra empty line detected at interface body beginning.
      end
    RBS

    expect_correction(<<~RBS)
      interface _Foo
        # Comment
        def foo: () -> void
      end

      interface _Bar
      end
    RBS
  end

  it 'does not register an offense when one line source' do
    expect_no_offenses(<<~RBS)
      interface _Foo end
    RBS
  end

  it 'does not register an offense when module' do
    expect_no_offenses(<<~RBS)
      module Foo

        def foo: () -> void

      end
    RBS
  end
end
