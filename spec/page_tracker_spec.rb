# frozen_string_literal: true

require 'spec_helper'
require 'page_tracker'
describe PageTracker do
  it 'adds log line' do
    page1 = double
    allow(Page).to receive(:new) { page1 }
    allow(page1).to receive(:add_visit)

    page_tracker = described_class.new
    page_tracker.add_log_line({ url: '/some/url', ip: '1.1.1.1' })

    expect(page1).to have_received(:add_visit).with('1.1.1.1')
  end

  it 'adds multiple log lines and adds visit to the correct page' do
    page1 = double
    page2 = double
    allow(Page).to receive(:new).and_return(page1, page2)
    allow(page1).to receive(:add_visit)
    allow(page2).to receive(:add_visit)

    page_tracker = described_class.new

    page_tracker.add_all([{ url: '/some/url', ip: '1.1.1.1' },
                          { url: '/some/url', ip: '1.1.1.2' },
                          { url: '/some/url2', ip: '1.1.1.3' }])

    expect(page1).to have_received(:add_visit).with('1.1.1.1')
    expect(page1).to have_received(:add_visit).with('1.1.1.2')
    expect(page2).to have_received(:add_visit).with('1.1.1.3')
  end

  it 'gets sorted visits' do
    double_pages = []
    (1..10).each do |i|
      d = double
      allow(d).to receive(:visits).and_return(i)
      allow(d).to receive(:add_visit)
      double_pages << d
    end

    allow(Page).to receive(:new).and_return(*double_pages)

    page_tracker = described_class.new

    (1..10).each do |i|
      page_tracker.add_log_line({ url: "/some/url#{i}", ip: "1.1.1.#{i}" })
    end

    result = page_tracker.visits
    expect(result).to eq([{ '/some/url10' => 10 },
                          { '/some/url9' => 9 },
                          { '/some/url8' => 8 },
                          { '/some/url7' => 7 },
                          { '/some/url6' => 6 },
                          { '/some/url5' => 5 },
                          { '/some/url4' => 4 },
                          { '/some/url3' => 3 },
                          { '/some/url2' => 2 },
                          { '/some/url1' => 1 }])
  end

  it 'gets sorted unique visits' do
    double_pages = []
    (1..10).each do |i|
      d = double
      allow(d).to receive(:unique_visits).and_return(i)
      allow(d).to receive(:add_visit)
      double_pages << d
    end

    allow(Page).to receive(:new).and_return(*double_pages)

    page_tracker = described_class.new

    (1..10).each do |i|
      page_tracker.add_log_line({ url: "/some/url#{i}", ip: "1.1.1.#{i}" })
    end

    result = page_tracker.unique_visits
    expect(result).to eq([{ '/some/url10' => 10 },
                          { '/some/url9' => 9 },
                          { '/some/url8' => 8 },
                          { '/some/url7' => 7 },
                          { '/some/url6' => 6 },
                          { '/some/url5' => 5 },
                          { '/some/url4' => 4 },
                          { '/some/url3' => 3 },
                          { '/some/url2' => 2 },
                          { '/some/url1' => 1 }])
  end
end
