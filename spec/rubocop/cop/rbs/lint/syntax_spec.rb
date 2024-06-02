# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Lint::Syntax, :config do
  it 'should registers an offense' do
    expect_offense(<<~RBS)
      class Foo
        def foo:: () -> void
               ^^ expected a token `pCOLON`, token=`::` (pCOLON2)
    RBS
  end
end
