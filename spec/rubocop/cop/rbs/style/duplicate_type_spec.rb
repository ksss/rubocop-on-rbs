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

        type t = (Integer | Integer)
                            ^^^^^^^ Duplicated type `Integer`.

        attr_accessor a: (Integer | Integer)
                                    ^^^^^^^ Duplicated type `Integer`.

        @var: (Integer | Integer)
                         ^^^^^^^ Duplicated type `Integer`.
      end

      $global: (Integer | Integer)
                          ^^^^^^^ Duplicated type `Integer`.
      CONST: (Integer | Integer)
                        ^^^^^^^ Duplicated type `Integer`.
    RBS

    expect_no_offenses(<<~RBS)
      class Foo
        def foo: ([Integer, Integer]) -> void
        def bar: ({a: Integer, b: Integer}) -> void
      end

      $global: Integer
    RBS
  end
end
