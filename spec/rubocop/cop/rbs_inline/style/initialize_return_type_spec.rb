# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Style::InitializeReturnType, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        def initialize #: nil
                          ^^^ `#initialize` method should return `void`
        end
      end

      class Bar
        # @rbs return: false
                       ^^^^^ `#initialize` method should return `void`
        def initialize
        end
      end

      class Baz
        #: () -> Baz
                 ^^^ `#initialize` method should return `void`
        def initialize
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        def initialize #: void
        end
      end

      class Bar
        # @rbs return: void
        def initialize
        end
      end

      class Baz
        #: () -> void
        def initialize
        end
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        def initialize #: void
        end

        # @rbs return: untyped
        def self.initialize
        end
      end

      class Bar
        #: () -> untyped
        def initialize
        end

        #: () -> nil
        def self.initialize
        end
      end
    RUBY
  end
end
