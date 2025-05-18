# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::Cop::RBS::Layout::EmptyLineBetweenDeclarations, :config do
  it 'registers an offense when class declarations' do
    expect_offense(<<~RBS)
      # Comment
      class A
      end
      # Comment
      class B
      ^^^^^^^ Expected 1 empty line between class definitions; found 0.
      end
    RBS

    expect_correction(<<~RBS)
      # Comment
      class A
      end

      # Comment
      class B
      end
    RBS
  end

  it 'registers an offense when module declarations' do
    expect_offense(<<~RBS)
      module A
      end
      %a{annotation}
      module B
      ^^^^^^^^ Expected 1 empty line between module definitions; found 0.
      end
    RBS

    expect_correction(<<~RBS)
      module A
      end

      %a{annotation}
      module B
      end
    RBS
  end

  it 'registers an offense when interface declarations' do
    expect_offense(<<~RBS)
      interface _A
      end
      # Comment
      %a{annotation}
      interface _B
      ^^^^^^^^^^^^ Expected 1 empty line between interface definitions; found 0.
      end
    RBS

    expect_correction(<<~RBS)
      interface _A
      end

      # Comment
      %a{annotation}
      interface _B
      end
    RBS
  end

  it 'registers an offense when class declarations with nested' do
    expect_offense(<<~RBS)
      module A
        module AA
          module AAA
            class B
            end
            module C
            ^^^^^^^^ Expected 1 empty line between module definitions; found 0.
            end
            interface _D
            ^^^^^^^^^^^^ Expected 1 empty line between interface definitions; found 0.
            end
          end
        end
      end
    RBS

    expect_correction(<<~RBS)
      module A
        module AA
          module AAA
            class B
            end

            module C
            end

            interface _D
            end
          end
        end
      end
    RBS
  end

  it 'registers an offense when class declarations with many empty lines' do
    expect_offense(<<~RBS)
      class A
      end


      class B
      ^^^^^^^ Expected 1 empty line between class definitions; found 2.
      end



      # Comment
      %a{annotation}
      class C
      ^^^^^^^ Expected 1 empty line between class definitions; found 3.
      end
      %a{annotationA} %a{annotationB} class D
                                      ^^^^^^^ Expected 1 empty line between class definitions; found 0.
      end
    RBS

    expect_correction(<<~RBS)
      class A
      end

      class B
      end

      # Comment
      %a{annotation}
      class C
      end

      %a{annotationA} %a{annotationB} class D
      end
    RBS
  end

  it 'not registers an offense if comment between declarations' do
    expect_no_offenses(<<~RBS)
      class A
      end

      # Comment

      class B
      end

      # Comment

      # Comment

      class C
      end
    RBS
  end
end
