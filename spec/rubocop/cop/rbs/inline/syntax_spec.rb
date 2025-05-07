# frozen_string_literal: true

# RSpec.xdescribe RuboCop::Cop::RBS::Inline::Syntax, :config do
#   it 'registers an offense' do
#     expect_offense(<<~RBS)
#       # class comments1
#       # class comments2
#       class Foo # :nodoc:
#         # @param comments1
#         # rbs comments2
#         # @rbs invalid -- comment
#                ^^^^^^^ Syntax error detected.
#         # @rbs return: Integer -- !invalid
#         def foo #: -invalid
#                    ^^^^^^^^ Syntax error detected.
#         end
#       end
#     RBS
#   end
# end
