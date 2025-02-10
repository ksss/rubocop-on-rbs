# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::NewReturnsVoid, :config do
  it 'should registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def self.new: () -> void
                            ^^^^ Don't use `void` in self.new method. Did you mean `instance`?
      end
    RBS
  end
end
