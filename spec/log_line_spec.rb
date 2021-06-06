# frozen_string_literal: true

require 'spec_helper'
require 'log_line'

describe LogLine do
  let(:options) { { parser: :some_parser, skip: true } }
  let(:p) { double }
  let(:log_line_parser) do
    class_double('LogLineParsers')
      .as_stubbed_const(transfer_nested_constants: true)
  end

  before do
    allow(log_line_parser).to receive(:get_parser).with(options[:parser]) { p }
    allow(p).to receive(:call).with('Some Log Line',
                                    options).and_return('PARSED_LINE')
  end

  it 'delegates parsing to correct parser and returns the correct parsing' do
    result = described_class.parse 'Some Log Line', options

    expect(result).to eq('PARSED_LINE')
  end
end
