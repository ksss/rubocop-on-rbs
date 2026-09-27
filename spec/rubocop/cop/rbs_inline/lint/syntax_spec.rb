# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Lint::Syntax, :config do
  it 'registers an offense for broken trailing annotation' do
    expect_offense(<<~RUBY)
      class Foo
        def foo #: Strin g
                 ^^^^^^^^^ Syntax error: expected a token `pEOF`, token=`: Strin g`
        end
      end
    RUBY
  end

  it 'registers an offense for broken leading annotation' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs x: Integer,
          ^^^^^^^^^^^^^^^^ Syntax error: expected a token `pEOF`, token=`@rbs x: Integer,`
        def foo(x)
        end
      end
    RUBY
  end

  it 'does not register an offense for valid annotations' do
    expect_no_offenses(<<~RUBY)
      class Foo
        attr_reader :bar #: Integer

        # @rbs x: Integer
        # @rbs return: String
        def foo(x)
        end

        def baz #: void
        end
      end
    RUBY
  end

  it 'ignores RDoc directives' do
    expect_no_offenses(<<~RUBY)
      class Foo #:nodoc:
        #:stopdoc:
        def foo #:nodoc:
        end

        attr_reader :bar #:nodoc: all
        X = 1 #:nodoc:
      end
    RUBY
  end

  it 'ignores RDoc directives even when the file has other annotations' do
    expect_no_offenses(<<~RUBY)
      class Foo
        def foo #: String
        end

        def bar #:nodoc:
        end
      end
    RUBY
  end

  it 'ignores embedded RBS (`# @rbs!`) by default' do
    expect_no_offenses(<<~RUBY)
      class Foo
        # @rbs!
        #   type t = Integer
      end
    RUBY
  end

  it 'does not touch .rbs files' do
    expect_no_offenses(<<~RBS, 'sig/foo.rbs')
      class Foo
        def foo: () -> void
      end
    RBS
  end

  context 'with AllowedPatterns' do
    let(:cop_config) { { 'AllowedPatterns' => ['\A#: TODO'] } }

    it 'ignores comments matching the pattern' do
      expect_no_offenses(<<~RUBY)
        class Foo
          def foo #: TODO later
          end
        end
      RUBY
    end
  end
end
