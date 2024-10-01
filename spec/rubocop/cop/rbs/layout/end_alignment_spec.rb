# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::EndAlignment, :config do
  it 'should registers an offense when simple case' do
    expect_offense(<<~RBS)
      class Foo
        end
        ^^^ `end` at 2, 2 is not aligned with `class Foo` at 1, 0.
    RBS

    expect_correction(<<~RBS)
      class Foo
      end
    RBS
  end

  it 'should registers an offense when level 3' do
    expect_offense(<<~RBS)
      class Foo
        module Bar
          interface _Baz
      end
      ^^^ `end` at 4, 0 is not aligned with `interface _Baz` at 3, 4.
          end
          ^^^ `end` at 5, 4 is not aligned with `module Bar` at 2, 2.
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        module Bar
          interface _Baz
          end
        end
      end
    RBS
  end

  it 'does not register an offense when one line source' do
    expect_no_offenses(<<~RBS)
      class Foo end
    RBS
  end
end
