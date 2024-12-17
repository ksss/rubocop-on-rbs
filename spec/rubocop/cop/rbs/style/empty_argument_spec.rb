# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::EmptyArgument, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def arg: -> void
                 ^ Insert `()` when empty argument
        def type: [ T ] -> void
                        ^ Insert `()` when empty argument
        def block: ({a: 1}) { -> void } -> void
                              ^ Insert `()` when empty argument
        def self_type: () { [self: instance] -> void } -> void
                            ^ Insert `()` when empty argument
        def proc_arg: (^ -> void) -> void
                         ^ Insert `()` when empty argument
        def proc_block: (^() { -> void } -> void) -> void
                               ^ Insert `()` when empty argument
        def proc_block_with_self_type: (^() { [self: instance] -> void } -> void) -> void
                                              ^ Insert `()` when empty argument
        def all: { -> ^{ -> void }-> void } -> void
                 ^ Insert `()` when empty argument
                   ^ Insert `()` when empty argument
                       ^ Insert `()` when empty argument
                         ^ Insert `()` when empty argument
        attr_reader attr: ^ -> void
                            ^ Insert `()` when empty argument
        @ivar: ^ -> void
                 ^ Insert `()` when empty argument
      end
      CONST: ^ -> void
               ^ Insert `()` when empty argument
      $global: ^ -> void
                 ^ Insert `()` when empty argument
      type typealias = ^ -> void
                         ^ Insert `()` when empty argument
    RBS

    expect_correction(<<~RBS)
      class Foo
        def arg: () -> void
        def type: [ T ] () -> void
        def block: ({a: 1}) { () -> void } -> void
        def self_type: () { () [self: instance] -> void } -> void
        def proc_arg: (^ () -> void) -> void
        def proc_block: (^() { () -> void } -> void) -> void
        def proc_block_with_self_type: (^() { () [self: instance] -> void } -> void) -> void
        def all: () { () -> ^() { () -> void }-> void } -> void
        attr_reader attr: ^ () -> void
        @ivar: ^ () -> void
      end
      CONST: ^ () -> void
      $global: ^ () -> void
      type typealias = ^ () -> void
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Foo
        def each: [T] () { () -> T } -> T
        def block_self_type: () { () [self: instance] -> void } -> void
      end
    RBS
  end
end
