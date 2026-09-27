# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Style::OptionalNil, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs @var: nil?
                     ^^^^ Use `nil` instead of `nil?`

        #: (nil?) -> void
            ^^^^ Use `nil` instead of `nil?`
        def foo(x)
        end

        # @rbs x: nil? | Integer
                  ^^^^ Use `nil` instead of `nil?`
        # @rbs return: [nil?]
                        ^^^^ Use `nil` instead of `nil?`
        def bar(x)
        end

        attr_accessor :a #: nil?
                            ^^^^ Use `nil` instead of `nil?`

        CONST = nil #: nil?
                       ^^^^ Use `nil` instead of `nil?`
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        # @rbs @var: nil

        #: (nil) -> void
        def foo(x)
        end

        # @rbs x: nil | Integer
        # @rbs return: [nil]
        def bar(x)
        end

        attr_accessor :a #: nil

        CONST = nil #: nil
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        #: (nil) -> void
        def foo(x)
        end

        CONST = nil
      end
    RUBY
  end
end
