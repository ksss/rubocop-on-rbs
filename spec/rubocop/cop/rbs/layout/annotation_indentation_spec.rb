# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::AnnotationIndentation, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      %a{ok}

        %a{none:class:annotation}
        ^^^^^^^^^^^^^^^^^^^^^^^^^ Incorrect indentation detected (column 0 instead of 2).

        %a{class:annotation}
        ^^^^^^^^^^^^^^^^^^^^ Incorrect indentation detected (column 0 instead of 2).
      class Foo
          %a{none:method:annotation}
          ^^^^^^^^^^^^^^^^^^^^^^^^^^ Incorrect indentation detected (column 2 instead of 4).

          %a{bad:method}
          ^^^^^^^^^^^^^^ Incorrect indentation detected (column 2 instead of 4).
        %a{correct:method}
        def initialize: () -> void

          %a{method:inline} def foo: %a{method:overload} () -> void
          ^^^^^^^^^^^^^^^^^ Incorrect indentation detected (column 2 instead of 4).

        %a{method:inline} def bar: () -> void
                                 | %a{method:overload} () -> void

          %a{pure} attr_reader a: Integer
          ^^^^^^^^ Incorrect indentation detected (column 2 instead of 4).

        interface _I
          def end: () -> void
        end

          %a{bad:annotation}
          ^^^^^^^^^^^^^^^^^^ Incorrect indentation detected (column 2 instead of 4).
        %a{correct:annotation}
        def self.foo: () -> void
      end
    RBS

    expect_correction(<<~RBS)
      %a{ok}

      %a{none:class:annotation}

      %a{class:annotation}
      class Foo
        %a{none:method:annotation}

        %a{bad:method}
        %a{correct:method}
        def initialize: () -> void

        %a{method:inline} def foo: %a{method:overload} () -> void

        %a{method:inline} def bar: () -> void
                                 | %a{method:overload} () -> void

        %a{pure} attr_reader a: Integer

        interface _I
          def end: () -> void
        end

        %a{bad:annotation}
        %a{correct:annotation}
        def self.foo: () -> void
      end
    RBS
  end
end
