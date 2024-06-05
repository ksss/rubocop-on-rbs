# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::CommentIndentation, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      # OK

        # None class comment
        ^^^^^^^^^^^^^^^^^^^^ Incorrect indentation detected (column 0 instead of 2).

        # Class comment
        ^^^^^^^^^^^^^^^ Incorrect indentation detected (column 0 instead of 2).
      class Foo
          # None method comment
          ^^^^^^^^^^^^^^^^^^^^^ Incorrect indentation detected (column 2 instead of 4).

          # Method comment
          ^^^^^^^^^^^^^^^^ Incorrect indentation detected (column 2 instead of 4).
        # Method comment2
        def initialize: () -> void

        interface _I
          def end: () -> void
        end

          # comment
          ^^^^^^^^^ Incorrect indentation detected (column 2 instead of 4).
        # comment
        def self.foo: () -> void
      end
    RBS

    expect_correction(<<~RBS)
      # OK

      # None class comment

      # Class comment
      class Foo
        # None method comment

        # Method comment
        # Method comment2
        def initialize: () -> void

        interface _I
          def end: () -> void
        end

        # comment
        # comment
        def self.foo: () -> void
      end
    RBS
  end
end
