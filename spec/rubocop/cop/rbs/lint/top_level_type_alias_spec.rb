# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::TopLevelTypeAlias, :config do
  it 'should registers an offense' do
    expect_offense(<<~RBS)
      type foo = String
      ^^^^^^^^^^^^^^^^^ Top level type alias detected.

      class Foo
      end

      class Foo
        module Bar
        end

        type bar = Integer
      end

      type baz = Integer
      ^^^^^^^^^^^^^^^^^^ Top level type alias detected.
    RBS
  end
end
