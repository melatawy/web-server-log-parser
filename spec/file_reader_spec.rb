# frozen_string_literal: true

require 'spec_helper'
require 'file_reader'
require 'tempfile'

describe FileReader do
  let(:file_reader_object) { described_class.new }
  let(:test_file) do
    file = Tempfile.new('some_file')
    (1..5).each do |i|
      file.write "This is line numeber #{i}\n"
    end
    file.close
    file
  end
  # before do

  # end

  after do
    test_file.unlink
  end

  it 'reads file content' do
    content = file_reader_object.read_file test_file
    expect(content).to eq([
                            'This is line numeber 1',
                            'This is line numeber 2',
                            'This is line numeber 3',
                            'This is line numeber 4',
                            'This is line numeber 5'
                          ])
  end
end
