# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::RestKeywordHash, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo: (**Hash[Symbol, String] rest) -> void
                    ^^^^^^^^^^^^^^^^^^^^ The type of `**` specifies only the type of value. Did you mean `**String`?
      end
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Bar
        def bar: (?) -> void
      end
    RBS
  end
end
