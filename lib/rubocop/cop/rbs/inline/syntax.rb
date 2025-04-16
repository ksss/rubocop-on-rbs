# # frozen_string_literal: true

# module RuboCop
#   module Cop
#     module RBS
#       module Inline
#         class Syntax < RuboCop::Cop::Base
#           include RuboCop::RBS::RBSHelper
#           MSG = "Syntax error detected.".freeze

#           def on_new_investigation
#             return
#             processed_source.comments.each do |comment|
#               source = comment.source
#               index = source.index(/[^#\s]/)
#               next if index.nil?

#               lex_result = ::RBS::Parser.lex(source[index..-1])

#               base_pos = comment.source_range.begin_pos + index
#               tokens = lex_result.value.reject { |token| token.type == :tTRIVIA }
#               next if tokens.empty?
#               next if tokens.length < 2

#               case tokens[0].type
#               when :pCOLON
#                 tokens.shift
#                 current = tokens.first
#                 start_pos = current.location.start_pos
#                 end_pos = (tokens.find { |token| token.type == :tINLINECOMMENT }&.location&.start_pos || tokens.last.location.end_pos)
#                 begin
#                   ::RBS::Parser.parse_method_type(source, range: start_pos..end_pos)
#                 rescue ::RBS::ParsingError => e
#                   range = range_between(start_pos + base_pos, end_pos + base_pos)
#                   add_offense(range, severity: :fatal)
#                 end
#               when :kATRBS
#                 tokens.shift
#                 current = tokens.first
#                 case current.type
#                 when :pLPAREN,
#                      :pLBRACKET,
#                      :pLBRACE,
#                      :tANNOTATION
#                 when :kSKIP
#                 when :kRETURN
#                 else
#                   range = range_between(current.location.start_pos + base_pos, current.location.end_pos + base_pos)
#                   add_offense(range, severity: :fatal)
#                 end
#               end
#             end
#           end
#         end
#       end
#     end
#   end
# end
