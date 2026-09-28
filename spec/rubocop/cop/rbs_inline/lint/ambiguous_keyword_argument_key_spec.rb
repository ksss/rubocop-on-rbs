# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Lint::AmbiguousKeywordArgumentKey, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        #: (option?: bool, option!: bool, Option: bool) -> void
                                          ^^^^^^ `Option` is not local variable name.
                           ^^^^^^^ `option!` is not local variable name.
            ^^^^^^^ `option?` is not local variable name. Did you mean `?option` for optional keyword argument?
        def foo(**)
        end

        # @rbs (?Option: bool) -> void
                 ^^^^^^ `Option` is not local variable name.
        def bar(**)
        end
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        #: (?option: bool) -> void
        def foo(option: false)
        end

        # @rbs option: bool
        def bar(option:)
        end
      end
    RUBY
  end
end
