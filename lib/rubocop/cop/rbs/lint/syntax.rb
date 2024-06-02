# frozen_string_literal: true

module RuboCop
  module Cop
    module RBS
      module Lint
        # Just only for syntax error
        class Syntax < Base
          def on_rbs_parsing_error
            e = processed_rbs_source.error
            message = "#{e.error_message}, token=`#{e.location.source}` (#{e.token_type})"
            add_offense(location_to_range(e.location), message:, severity: :fatal)
          end
        end
      end
    end
  end
end
