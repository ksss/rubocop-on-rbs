# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::OptionalNil, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: (nil?) -> void
                  ^^^^ Use `nil` instead of `nil?`
        def bar: ((nil? | Integer), (nil? & Integer), [nil?], { a: nil? }) -> void
                   ^^^^ Use `nil` instead of `nil?`
                                     ^^^^ Use `nil` instead of `nil?`
                                                       ^^^^ Use `nil` instead of `nil?`
                                                                   ^^^^ Use `nil` instead of `nil?`
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def foo: (nil) -> void
        def bar: ((nil | Integer), (nil & Integer), [nil], { a: nil }) -> void
      end
    RBS
  end
end
