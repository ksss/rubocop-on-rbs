# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::IndentationWidth, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
      def initialize: () -> void
      ^{} Use 2 (not 0) spaces for indentation.
          alias foo bar
      ^^^^ Use 2 (not 4) spaces for indentation.
            type t = Integer
      ^^^^^^ Use 2 (not 6) spaces for indentation.
              @attr: Integer
      ^^^^^^^^ Use 2 (not 8) spaces for indentation.
                %a{a} def a: () -> void
      ^^^^^^^^^^ Use 2 (not 10) spaces for indentation.
                  # See Layout/CommentIndentation
                  %a{see:layout:annotation_indentation}
                  def b: () -> void
      ^^^^^^^^^^^^ Use 2 (not 12) spaces for indentation.
      end
        CONST: 1
      ^^ Use 0 (not 2) spaces for indentation.
          $global: Integer
      ^^^^ Use 0 (not 4) spaces for indentation.
            class Baz = Foo
      ^^^^^^ Use 0 (not 6) spaces for indentation.
    RBS

    expect_correction(<<~RBS)
      class Foo
        def initialize: () -> void
        alias foo bar
        type t = Integer
        @attr: Integer
        %a{a} def a: () -> void
                  # See Layout/CommentIndentation
                  %a{see:layout:annotation_indentation}
        def b: () -> void
      end
      CONST: 1
      $global: Integer
      class Baz = Foo
    RBS
  end

  it 'not registers an offense' do
    expect_no_offenses(<<~RBS)
      # Comment
      class Foo
        # Comment
        %a{annotation} def anno: () -> void
        %a{annotation}
        def bar: () -> void
      end
    RBS
  end

  it 'should get indentation width level 3' do
    expect_offense(<<~RBS)
      module Foo
        module Bar
          module Baz
      def foo: () -> void
      ^{} Use 6 (not 0) spaces for indentation.

        def bar: () -> void
      ^^ Use 6 (not 2) spaces for indentation.
          end
        end
      end
    RBS

    expect_correction(<<~RBS)
      module Foo
        module Bar
          module Baz
            def foo: () -> void

            def bar: () -> void
          end
        end
      end
    RBS
  end

  it 'should register an offense in module' do
    expect_offense(<<~RBS, "a.rbs")
      module Foo
          module Bar
      ^^^^ Use 2 (not 4) spaces for indentation.
        module Baz
      ^^ Use 4 (not 2) spaces for indentation.
          end
        end
      end
    RBS

    expect_correction(<<~RBS)
      module Foo
        module Bar
          module Baz
          end
        end
      end
    RBS
  end
end
