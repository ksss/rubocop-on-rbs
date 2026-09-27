# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Lint::UnusedAnnotation, :config do
  it 'registers an offense when a blank line separates the annotation from def' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs x: Integer
          ^^^^^^^^^^^^^^^ Unused inline rbs annotation

        def foo(x)
        end
      end
    RUBY
  end

  it 'registers an offense when the annotation is not followed by a definition' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs x: Integer
          ^^^^^^^^^^^^^^^ Unused inline rbs annotation
        puts 1
      end
    RUBY
  end

  it 'registers an offense for an unknown parameter name' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs y: Integer
          ^^^^^^^^^^^^^^^ Unused inline rbs annotation
        def foo(x)
        end
      end
    RUBY
  end

  it 'registers an offense only for the annotation line in a mixed comment block' do
    expect_offense(<<~RUBY)
      class Foo
        # Some documentation
        # @rbs x: Integer
          ^^^^^^^^^^^^^^^ Unused inline rbs annotation
        puts 1
      end
    RUBY
  end

  it 'does not register an offense for used annotations' do
    expect_no_offenses(<<~RUBY)
      class Foo
        # Some documentation
        # @rbs x: Integer
        # @rbs return: String
        def foo(x)
        end

        # @rbs skip
        def bar
        end

        attr_reader :baz #: Integer
      end
    RUBY
  end

  it 'does not register an offense for plain comments and RDoc directives' do
    expect_no_offenses(<<~RUBY)
      class Foo #:nodoc:
        # hello
        # :nodoc:
        def foo
        end
      end
    RUBY
  end
end
