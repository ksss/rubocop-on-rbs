# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RuboCop::RBS::CopBase do
  describe '#documentation_url' do
    it 'returns documentation URL' do
      url = "https://github.com/ksss/rubocop-on-rbs/blob/v#{RuboCop::RBS::VERSION}/docs/modules/ROOT/pages/cops_rbs_layout.adoc#rbslayouttrailingwhitespace"
      expect(RuboCop::Cop::RBS::Layout::TrailingWhitespace.documentation_url).to eq(url)
    end

    it 'returns documentation URL with config' do
      config = RuboCop::Config.new
      url = "https://github.com/ksss/rubocop-on-rbs/blob/v#{RuboCop::RBS::VERSION}/docs/modules/ROOT/pages/cops_rbs_layout.adoc#rbslayouttrailingwhitespace"
      expect(RuboCop::Cop::RBS::Layout::TrailingWhitespace.documentation_url(config)).to eq(url)
    end
  end
end
