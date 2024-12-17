# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::SpaceAroundOperators, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      $global: Integer|String
                      ^ Use one space before `|`.
      class Foo
        def union_before: (Integer| String) -> void
                                  ^ Use one space before `|`.
        def union_after: (Integer |String) -> void
                                  ^ Use one space after `|`.
        def union_both: (Integer|String) -> void
                                ^ Use one space before `|`.
        def intersecion_before: (Integer& String) -> void
                                        ^ Use one space before `&`.
        def intersecion_after: (Integer &String) -> void
                                        ^ Use one space after `&`.
        def intersecion_both: (Integer&String) -> void
                                      ^ Use one space before `&`.
        def paren: (((1)|(2))&((3)|(4))) -> void
                        ^ Use one space before `|`.
                             ^ Use one space before `&`.
                                  ^ Use one space before `|`.
        CONST: Integer|String
                      ^ Use one space before `|`.
        type t = Integer|String
                        ^ Use one space before `|`.
        attr_reader a: Integer|String
                              ^ Use one space before `|`.
        @ivar: Integer|String
                      ^ Use one space before `|`.
      end
    RBS

    expect_correction(<<~RBS)
      $global: Integer | String
      class Foo
        def union_before: (Integer | String) -> void
        def union_after: (Integer | String) -> void
        def union_both: (Integer | String) -> void
        def intersecion_before: (Integer & String) -> void
        def intersecion_after: (Integer & String) -> void
        def intersecion_both: (Integer & String) -> void
        def paren: (((1) | (2)) & ((3) | (4))) -> void
        CONST: Integer | String
        type t = Integer | String
        attr_reader a: Integer | String
        @ivar: Integer | String
      end
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Foo
        def paren: (( 1 | 2 ) & ( 3 | 4 )) -> void
        CONST: Integer
      end
    RBS
  end
end
