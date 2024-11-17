# frozen_string_literal: true

require 'rubocop-on-rbs'
require 'rubocop/rspec/support'

RuboCop::RSpec::ExpectOffense.prepend(Module.new do
  # skip ruby syntax check
  def parse_processed_source(source, file = nil)
    parse_source(source, file).tap do
      begin
        ::RBS::Parser.parse_signature(source)
      rescue ::RBS::ParsingError => e
        $stderr.puts e.detailed_message
      end
    end
  end

  def expect_correction(correction, loop: true, source: nil)
    super
  rescue RSpec::Expectations::ExpectationNotMetError => e
    if e.message == 'Expected correction to be valid syntax'
      true
    else
      raise
    end
  end
end)

module CopHelperHack
  def inspect_source(source, file = nil)
    RuboCop::Formatter::DisabledConfigFormatter.config_to_allow_offenses = {}
    RuboCop::Formatter::DisabledConfigFormatter.detected_styles = {}
    processed_source = parse_source(source, file)
    # unless processed_source.valid_syntax?
    #   raise 'Error parsing example code: ' \
    #         "#{processed_source.diagnostics.map(&:render).join("\n")}"
    # end

    _investigate(cop, processed_source)
  end
end

RSpec.configure do |config|
  config.include RuboCop::RSpec::ExpectOffense
  config.include CopHelperHack

  config.disable_monkey_patching!
  config.raise_errors_for_deprecations!
  config.raise_on_warning = true
  config.fail_if_no_examples = true

  config.order = :random
  Kernel.srand config.seed
end
