# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Style::EmptyArgument, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs @ivar: ^ -> void
                        ^ Insert `()` when empty argument

        #: -> void
           ^ Insert `()` when empty argument
        def arg
        end

        #: [T] -> void
               ^ Insert `()` when empty argument
        def type
        end

        #: () { -> void } -> void
                ^ Insert `()` when empty argument
        def block
        end

        #: (^ -> void) -> void
              ^ Insert `()` when empty argument
        def proc_arg(x)
        end

        # @rbs x: ^ -> void
                    ^ Insert `()` when empty argument
        # @rbs return: ^ -> void
                         ^ Insert `()` when empty argument
        def doc_style(x)
        end

        attr_reader :attr #: ^ -> void
                               ^ Insert `()` when empty argument

        CONST = nil #: ^ -> void
                         ^ Insert `()` when empty argument
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        # @rbs @ivar: ^ () -> void

        #: () -> void
        def arg
        end

        #: [T] () -> void
        def type
        end

        #: () { () -> void } -> void
        def block
        end

        #: (^ () -> void) -> void
        def proc_arg(x)
        end

        # @rbs x: ^ () -> void
        # @rbs return: ^ () -> void
        def doc_style(x)
        end

        attr_reader :attr #: ^ () -> void

        CONST = nil #: ^ () -> void
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        #: [T] () { () -> T } -> T
        def each
        end

        # @rbs x: ^() -> void
        def doc_style(x)
        end

        CONST = 1
      end
    RUBY
  end
end
