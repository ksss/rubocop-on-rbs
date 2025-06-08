# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::ImplicitlyReturnsNil, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        %a{implicitly-returns-nil}
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ There is a conflict between `%a{implicitly-returns-nil}` and return type `Integer?`.
        def foo: () -> Integer?

        def bar: %a|implicitly-returns-nil| () -> (Integer | nil)
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^ There is a conflict between `%a|implicitly-returns-nil|` and return type `Integer | nil`.

        %a{implicitly-returns-nil}
        ^^^^^^^^^^^^^^^^^^^^^^^^^^ There is a conflict between `%a{implicitly-returns-nil}` and return type `nil`.
        def baz: () -> nil
      end
    RBS
  end
end
