# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Lint::NewReturnsVoid, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        def self.new #: void
                        ^^^^ Don't use `void` in self.new method. Did you mean `instance`?
        end

        # @rbs return: void
                       ^^^^ Don't use `void` in self.new method. Did you mean `instance`?
        def self.new
        end
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        def self.new #: instance
        end

        def new #: void
        end
      end
    RUBY
  end
end
