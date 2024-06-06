# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::DuplicateOverload, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () -> void
               | () -> top
               | () -> void
                 ^^^^^^^^^^ Duplicate overload body detected.
        def bar: () -> top
               | () { () -> top } -> top
               | () { () -> top } -> top
                 ^^^^^^^^^^^^^^^^^^^^^^^ Duplicate overload body detected.
      end
    RBS
  end
end
