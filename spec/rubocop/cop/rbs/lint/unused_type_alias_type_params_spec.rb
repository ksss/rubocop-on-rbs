# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::UnusedTypeAliasTypeParams, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        type ary[T] = Array[Integer]
                 ^ Unused type variable - `T`.

        type upper_bound[T < Array[Integer]] = Array[Integer]
                         ^ Unused type variable - `T`.
      end

      class Bar[A]
        type ary[B] = Array[A]
                 ^ Unused type variable - `B`.
      end
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Foo
        type i = Integer
        type ary[T] = Array[T]
      end
    RBS
  end
end
