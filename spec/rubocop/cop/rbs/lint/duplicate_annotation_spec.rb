# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::DuplicateAnnotation, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        %a{foo} %a{bar} %a{foo} def foo: () -> void
                        ^^^^^^^ Duplicate annotation detected.

        %a{foo} def foo: %a{bar} () -> void
                       | %a{foo} () -> void
                         ^^^^^^^ Duplicate annotation detected.

        def foo: %a{foo} %a{bar} %a{foo} () -> void
                                 ^^^^^^^ Duplicate annotation detected.
      end
    RBS
  end

  it 'does not register an offense' do
    expect_no_offenses(<<~RBS)
      class Foo
        def foo: %a{foo} () -> void
               | %a{foo} () -> void
      end
    RBS
  end
end
