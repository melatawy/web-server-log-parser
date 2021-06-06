# frozen_string_literal: true

require 'spec_helper'
require 'parsers'

describe LogLineParsers do
  it 'gets available parsers' do
    expect(
      described_class::AVAILABLE_PARSERS
    ).to eq([LogLineParsers::URL_AND_IP_PARSER])
  end

  context 'when requesting a parser' do
    it 'raises an exception if parser not supported' do
      expect do
        described_class.get_parser('SOME_ARBITRARY_PARSER')
      end.to raise_error('Unsupported Parser')
    end

    it 'gets a proc if requested' do
      parser = described_class.get_parser LogLineParsers::URL_AND_IP_PARSER

      expect(parser).is_a? Proc
    end

    it 'gets a proc with two arguments' do
      parser = described_class.get_parser LogLineParsers::URL_AND_IP_PARSER

      expect(parser.arity).to eq(2)
    end
  end

  context 'when requesting a url and ip parser' do
    it 'parses a valid log line correctly' do
      parser = described_class.get_parser LogLineParsers::URL_AND_IP_PARSER
      parsed = parser.call '/some/url 1.1.1.1', {}
      expect(parsed).to eq({ ip: '1.1.1.1', url: '/some/url' })
    end

    context 'with skipping invalid lines' do
      it 'skips parsing an invalid log line' do
        parser = described_class.get_parser LogLineParsers::URL_AND_IP_PARSER
        parsed = parser.call '/some/url/with/no/separator/1.1.1.1',
                             { skip: true }
        expect(parsed).to eq(nil)
      end

      it 'skips parsing a log line with invalid ip case string' do
        parser = described_class.get_parser LogLineParsers::URL_AND_IP_PARSER
        parsed = parser.call '/some/url someWrongIpHere',
                             { skip: true, validate_ip: true }
        expect(parsed).to eq(nil)
      end

      it 'skips parsing a log line with invalid ip case string.string.*' do
        parser = described_class.get_parser LogLineParsers::URL_AND_IP_PARSER
        parsed = parser.call '/some/url some.wrong.ip.here',
                             { skip: true, validate_ip: true }
        expect(parsed).to eq(nil)
      end
    end

    context 'with raising errors if malformed line found' do
      it 'raises an error for malformed log line' do
        parser = described_class.get_parser LogLineParsers::URL_AND_IP_PARSER

        expect do
          parser.call 'some malformed log line with too many segments', {}
        end.to raise_error('Malformated logline found some malformed '\
                          'log line with too many segments')
      end

      it 'raises an error for invalid ip case string' do
        parser = described_class.get_parser LogLineParsers::URL_AND_IP_PARSER

        expect do
          parser.call '/some/url someWrongIpHere', { validate_ip: true }
        end.to raise_error('Malformated logline found '\
                           '/some/url someWrongIpHere')
      end
    end
  end
end
