# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Style::InitializeReturnType, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def initialize: () -> untyped
                              ^^^^^^^ `#initialize` method should return `void`
      end
    RBS

    expect_correction(<<~RBS)
      class Foo
        def initialize: () -> void
      end
    RBS
  end
end
