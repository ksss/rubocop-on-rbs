# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::NewReturnsVoid, :config do
  it 'should registers an offense' do
    expect_offense(<<~RBS, "a.rbs")
      class Foo
        def self.new: () -> void
                            ^^^^ Don't use `void` in self.new method. Did you mean `instance`?
      end
    RBS
  end

  it 'should not register an offense on ruby' do
    expect_offense(<<~RUBY, "a.rb")
      class Foo
        class << self
          # @rbs return: void
                         ^^^^ Don't use `void` in self.new method. Did you mean `instance`?
          def new
          end
        end
      end
    RUBY
  end
end
