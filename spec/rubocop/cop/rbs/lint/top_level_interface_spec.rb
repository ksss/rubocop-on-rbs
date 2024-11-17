# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::TopLevelInterface, :config do
  it 'should registers an offense' do
    expect_offense(<<~RBS)
      interface _Foo
      ^^^^^^^^^^^^^^ Top level interface detected.
        def foo: () -> untyped
      end

      class Foo
      end

      class Foo
        module Bar
        end

        interface _Foo
          def foo: () -> untyped
        end
      end

      interface _Bar
      ^^^^^^^^^^^^^^ Top level interface detected.
        def bar: () -> untyped
      end
    RBS
  end
end
