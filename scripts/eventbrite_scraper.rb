# Scrape Eventbrite for events that match keywords.
# Usage:
# - gem install oga
# - ruby eventbrite_scraper.rb --city ma--boston --date this-month --keywords startup,pitch,"demo day" --output ~/Desktop/events.md

require 'tmpdir'
require 'date'
require 'optparse'
require 'open-uri'
require 'oga'

DEFAULT_CITY = 'ma--boston'
DEFAULT_DATE_FILTERS = %w{ this-month next-month }
DEFAULT_KEYWORDS = %w{ startup start-up founder co-founder entrepreneur entrepreneurs entrepreneurship pitch networking mixer tech technology }
DEFAULT_OUTPUT_PATH = File.expand_path('~/Desktop/eventbrite_events.md')
VALID_DATE_FILTERS = %w{ today tomorrow this-weekend this-week next-week this-month next-month }
INIT_SLEEP_DELAY_SECONDS = 2

# Ensure the cache directory exists.
CACHE_DIR_PATH = File.join(Dir.tmpdir, 'eventbrite_scraper_cache')
Dir.mkdir(CACHE_DIR_PATH) unless Dir.exists?(CACHE_DIR_PATH)

class EventbriteScraper
  def initialize
    @filter_city = DEFAULT_CITY
    @filter_dates = DEFAULT_DATE_FILTERS
    @filter_keywords = DEFAULT_KEYWORDS
    @output_path = DEFAULT_OUTPUT_PATH
    @use_cache = false
    @filtered_events = []
  end

  def perform
    parse_args
    scrape_events
    output_events
  end

  private

  def parse_args
    OptionParser.new do |opts|
      opts.banner = 'Usage: eventbrite_scraper.rb [options]'

      opts.on('-c', '--city CITY', 'events for which city') do |city|
        @filter_city = city
      end

      opts.on('-d', "--dates <#{VALID_DATE_FILTERS.join(',')}>", Array, 'events for which dates') do |dates|
        @filter_dates = dates
      end

      opts.on('-k', '--keywords WORD1,WORD2,WORD3', Array, 'event title keywords') do |keywords|
        @filter_keywords = keywords
      end

      opts.on('-o', '--output PATH', 'output Markdown file') do |path|
        @output_path = File.expand_path(path)
      end

      opts.on('--use-cache', 'use cached Eventbrite pages') do
        @use_cache = true
      end
    end.parse!
  end

  def scrape_events
    puts "Scraping Criteria"
    puts "==> city: #{@filter_city}"
    puts "==> dates: #{@filter_dates.join(', ')}"
    puts "==> keywords: #{@filter_keywords.join(', ')}"
    puts "==> output path: #{@output_path}"
    puts "==> using cache: #{@use_cache}"
    puts "====> cache dir: #{CACHE_DIR_PATH}"

    sleep_delay_seconds = INIT_SLEEP_DELAY_SECONDS
    filter_keywords_regex = /\b(#{@filter_keywords.join('|')})\b/i

    current_page = 1
    current_date = @filter_dates.shift

    while true do
      begin
        puts "Scraping #{current_date}'s events for page #{current_page}..."
        new_events = events_for_page(@filter_city, current_date, current_page)
      rescue OpenURI::HTTPError => e
        if e.message.include?('rate')
          puts "Rate Limited: Sleeping for #{sleep_delay_seconds} seconds and then retrying..."
          sleep(sleep_delay_seconds)
          sleep_delay_seconds *= 2
          next
        else
          puts "Unexpected error: #{e.message}"
          abort
        end
      end

      if new_events.empty?
        puts "Search ended for '#{current_date}'."
        if (current_date = @filter_dates.shift)
          current_page = 1
          next
        else
          break
        end
      end

      new_events.select! do |e|
        (filter_keywords_regex.match?(e[:title]) || filter_keywords_regex.match?(e[:location])) && e[:date] > DateTime.now
      end
      puts "==> Found #{new_events.count} relevant events."

      @filtered_events += new_events
      current_page += 1
      sleep_delay_seconds = 2 # reset
    end

    @filtered_events.uniq! { |event| event[:title] + event[:date].to_s }
    @filtered_events.sort_by! { |event| event[:date] }
  end

  def output_events
    out_file = File.open(@output_path, 'w')

    @filtered_events.each do |event|
      date = event[:date].strftime('%a, %e %b %H:%M %p')
      out_file.puts("- [#{event[:title]} | #{date}](#{event[:link]})")
    end

    puts "Done! #{out_file.path}"
  end

  def events_for_page(city, date, page)
    cached_events_dump = File.join(CACHE_DIR_PATH, "city_#{city}__date_#{date}__page_#{page}")

    if @use_cache && File.exists?(cached_events_dump)
      puts "==> Reading from cache..."
      return Marshal.load(File.binread(cached_events_dump)) # read from cache
    end

    puts "==> Making request to Eventbrite..."
    url = "https://www.eventbrite.com/d/#{city.downcase}/events--#{date.downcase}/?page=#{page}"
    doc = Oga.parse_xml(open(url).read)

    return [] if doc.at_css('.search-no-results')

    events = doc.css(".search-main-content__events-list > li").map do |node|
      {
        title: node.at_css('.eds-media-card-content__action-link .eds-is-hidden-accessible').text.strip,
        location: node.at_css('.eds-media-card-content__sub-content .eds-media-card-content__sub-content-cropped > div:first-child').text.strip,
        link: node.at_css('.eds-media-card-content__action-link')['href'].strip,
        date: DateTime.parse(node.at_css('.eds-media-card-content__sub-content > div:first-child').text.strip),
      }
    end

    File.binwrite(cached_events_dump, Marshal.dump(events)) # cache events

    events
  end
end

EventbriteScraper.new.perform
