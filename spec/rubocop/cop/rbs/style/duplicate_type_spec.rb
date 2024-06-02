# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::DuplicatedType, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: (Integer | Integer) -> void
                            ^^^^^^^ Duplicated type `Integer`.

        def bar: () -> (Integer & String & Integer)?
                                           ^^^^^^^ Duplicated type `Integer`.

        def baz: ([Integer | Integer], {a: Integer | Integer}) -> void
                             ^^^^^^^ Duplicated type `Integer`.
                                                     ^^^^^^^ Duplicated type `Integer`.
       end
    RBS

    expect_no_offenses(<<~RBS)
      class Foo
        def foo: ([Integer, Integer]) -> void
        def bar: ({a: Integer, b: Integer}) -> void
      end
    RBS
  end
end
