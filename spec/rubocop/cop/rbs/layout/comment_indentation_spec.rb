# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::CommentIndentation, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
        # None class comment
        ^^^^^^^^^^^^^^^^^^^^ Incorrect indentation detected (column 0 instead of 2).

      class Foo
        # empty
      end

        # Class comment
        ^^^^^^^^^^^^^^^ Incorrect indentation detected (column 0 instead of 2).
      class Foo
          # None method comment
          ^^^^^^^^^^^^^^^^^^^^^ Incorrect indentation detected (column 2 instead of 4).

        def foo: () -> void

          # Method comment
          ^^^^^^^^^^^^^^^^ Incorrect indentation detected (column 2 instead of 4).
        # Method comment2
        def initialize: () -> void

        def comment_in_arguments: (
          ?aaa: Integer,
          # comment
          ?bbb: String,
        ) -> void

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
      # None class comment

      class Foo
        # empty
      end

      # Class comment
      class Foo
        # None method comment

        def foo: () -> void

        # Method comment
        # Method comment2
        def initialize: () -> void

        def comment_in_arguments: (
          ?aaa: Integer,
          # comment
          ?bbb: String,
        ) -> void

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
