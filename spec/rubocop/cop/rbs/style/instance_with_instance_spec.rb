# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::InstanceWithInstance, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: () -> instance
                       ^^^^^^^^ Use `self` instead of `instance`.

        def self.foo: () -> instance

        def self?.foo: () -> instance

        @ivar: instance
               ^^^^^^^^ Use `self` instead of `instance`.

        @@cvar: instance

        self.@civar: instance
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: () -> self

        def self.foo: () -> instance

        def self?.foo: () -> instance

        @ivar: self

        @@cvar: instance

        self.@civar: instance
      end
    RBS
  end
end
