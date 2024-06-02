# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::ExtraSpacing, :config do
  it 'registers an offense' do
    expect_offense(<<~RBS)
      class      Foo   <   Bar      # Comment
           ^^^^^ Unnecessary spacing detected.
                    ^^ Unnecessary spacing detected.
                        ^^ Unnecessary spacing detected.
                              ^^^^^ Unnecessary spacing detected.
        def foo: () -> void     # Comment
               | () -> void     # Comment

        def  bar  :  (  )  ->  void
           ^ Unnecessary spacing detected.
                ^ Unnecessary spacing detected.
                   ^ Unnecessary spacing detected.
                      ^ Unnecessary spacing detected.
                         ^ Unnecessary spacing detected.
                             ^ Unnecessary spacing detected.
      end
    RBS

    expect_correction(<<~RBS)
      class Foo < Bar # Comment
        def foo: () -> void     # Comment
               | () -> void     # Comment

        def bar : ( ) -> void
      end
    RBS
  end
end
