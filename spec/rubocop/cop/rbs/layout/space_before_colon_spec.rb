# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::SpaceBeforeColon, :config do
  it 'registers an offense with space before colon' do
    expect_offense(<<~RBS)
      # Hello
      class Foo
        def foo : () -> ::Time
                ^ Avoid using spaces before `:`.
               | () -> ::Time

        def bar   : () -> ::Time
                  ^ Avoid using spaces before `:`.
               | () -> ::Time
      end
    RBS

    expect_correction(<<~RBS)
      # Hello
      class Foo
        def foo: () -> ::Time
               | () -> ::Time

        def bar: () -> ::Time
               | () -> ::Time
      end
    RBS
  end
end
