# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/rbs'
require_relative 'rubocop/rbs/version'
require_relative 'rubocop/rbs/on_type_helper'
require_relative 'rubocop/rbs/cop_base'
require_relative 'rubocop/rbs/inject'
require_relative 'rubocop/rbs/processed_rbs_source'

RuboCop::RBS::Inject.defaults!

require_relative 'rubocop/cop/rbs_cops'
