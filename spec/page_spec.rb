# frozen_string_literal: true

require 'spec_helper'
require 'page'
describe Page do
  let(:page) { described_class.new 'SOME_URL' }

  it 'has zero visits if nothing added' do
    expect(page.visits).to eq(0)
  end

  it 'has zero unique visits if nothing added' do
    expect(page.unique_visits).to eq(0)
  end

  it 'has correct number of visits' do
    page.add_visit '1.1.1.1'
    page.add_visit '1.1.1.1'
    page.add_visit '1.1.1.2'

    expect(page.visits).to eq(3)
  end

  it 'has correct number of unique visits' do
    page.add_visit '1.1.1.1'
    page.add_visit '1.1.1.1'
    page.add_visit '1.1.1.2'

    expect(page.unique_visits).to eq(2)
  end
end
