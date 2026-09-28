# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBSInline::Lint::RestKeywordHash, :config do
  it 'registers an offense' do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs **opts: Hash[Symbol, String]
                       ^^^^^^^^^^^^^^^^^^^^ The type of `**` specifies only the type of value. Did you mean `**String`?
        def foo(**opts)
        end

        #: (**Hash[Symbol, String]) -> void
              ^^^^^^^^^^^^^^^^^^^^ The type of `**` specifies only the type of value. Did you mean `**String`?
        def bar(**opts)
        end
      end
    RUBY
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RUBY)
      class Foo
        # @rbs **opts: String
        def foo(**opts)
        end

        # @rbs opts: Hash[Symbol, String]
        def bar(opts)
        end
      end
    RUBY
  end
end
