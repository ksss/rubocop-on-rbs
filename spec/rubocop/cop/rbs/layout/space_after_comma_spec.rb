# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::SpaceAfterComma, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo[A,B]
                 ^ Space missing after comma.
        def foo: [T,U] (Integer,String,*rest,foo: Integer,?bar: String,**kwrest) -> void
                   ^ Space missing after comma.
                               ^ Space missing after comma.
                                      ^ Space missing after comma.
                                            ^ Space missing after comma.
                                                         ^ Space missing after comma.
                                                                      ^ Space missing after comma.
        type hash[K,V] = Hash[K,V]
                   ^ Space missing after comma.
                               ^ Space missing after comma.
      end
    RBS

    expect_correction(<<~RBS)
      class Foo[A, B]
        def foo: [T, U] (Integer, String, *rest, foo: Integer, ?bar: String, **kwrest) -> void
        type hash[K, V] = Hash[K, V]
      end
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Foo
        def foo: (
          Integer,
          String,
          *rest,
          foo: Integer,
          ?bar: String,
          **kwrest
        ) -> void
      end
    RBS
  end
end
