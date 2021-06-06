# frozen_string_literal: true

require 'spec_helper'

require 'dry-container'
require 'dry-auto_inject'

require './parser_ioc_container'

require 'web_server_parser'

describe WebServerParser do
  it 'parses log file' do
    wsp = described_class.new

    allow(wsp.file_reader).to receive(:read_file)
      .and_return([
                    '/url/1 1.1.1.1',
                    '/url/2 1.1.1.2',
                    '/url/3 1.1.1.3',
                    '/url/1 1.1.1.2'
                  ])

    ll = class_double('LogLine')
      .as_stubbed_const(transfer_nested_constants: true)
    allow(ll).to receive(:parse)

    allow(wsp.page_tracker).to receive(:add_all)
    allow(wsp.page_tracker).to receive(:visits)
      .and_return('VISITS_OUTPUT')
    allow(wsp.page_tracker).to receive(:unique_visits)
      .and_return('UNIQUE_VISITS_OUTPUT')

    result = wsp.parse 'log_file_name', {}
    expect(result).to eq(%w[VISITS_OUTPUT UNIQUE_VISITS_OUTPUT])
  end
end
