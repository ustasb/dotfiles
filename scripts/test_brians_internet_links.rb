# Script for testing my internet links.
# Relies on curl: https://curl.haxx.se/
# Usage: `test_brians_internet_links.rb`

def build_url_test_data
  data = []

  # format: [<test-url> <...expected-http-codes> <expected-final-redirect-url>?]

  # officesnake.com
  data << %w{ http://officesnake.com     200 }
  data << %w{ http://www.officesnake.com 301 200 http://officesnake.com/ }

  # pandify.com
  data << %w{ http://pandify.com     200 }
  data << %w{ http://www.pandify.com 301 200 http://pandify.com/ }

  # hitpic.me
  # This app is hosted by Heroku. I don't have access to the reverse proxy config.
  # Thus, the www version is the primary.
  data << %w{ http://www.hitpic.me  200 }
  data << %w{ http://hitpic.me      302 200 http://www.hitpic.me }

  # ustasb.com
  data << %w{ http://ustasb.com     301 200 http://brianustas.com/ }
  data << %w{ http://www.ustasb.com 301 200 http://brianustas.com/ }

  # brianustas.com
  data << %w{ http://brianustas.com     200 }
  data << %w{ http://www.brianustas.com 301 200 http://brianustas.com/ }

  data << %w{ http://brianustas.com/campus-safety-dashboard/  200 }
  data << %w{ http://brianustas.com/campus-safety-dashboard   301 200 http://brianustas.com/campus-safety-dashboard/ }

  data << %w{ http://brianustas.com/where-in-the-world/ 200 }
  data << %w{ http://brianustas.com/where-in-the-world  301 200 http://brianustas.com/where-in-the-world/ }
  data << %w{ http://brianustas.com/whereintheworld/    301 200 http://brianustas.com/where-in-the-world/ } # legacy
  data << %w{ http://brianustas.com/whereintheworld     301 200 http://brianustas.com/where-in-the-world/ } # legacy

  data << %w{ http://brianustas.com/emoji-soup/ 200 }
  data << %w{ http://brianustas.com/emoji-soup  301 200 http://brianustas.com/emoji-soup/ }
  data << %w{ http://brianustas.com/emojisoup/  301 200 http://brianustas.com/emoji-soup/ } # legacy
  data << %w{ http://brianustas.com/emojisoup   301 200 http://brianustas.com/emoji-soup/ } # legacy

  data << %w{ http://brianustas.com/free-donut/ 200 }
  data << %w{ http://brianustas.com/free-donut  301 200 http://brianustas.com/free-donut/ }
  data << %w{ http://brianustas.com/freedonut/  301 200 http://brianustas.com/free-donut/ } # legacy
  data << %w{ http://brianustas.com/freedonut   301 200 http://brianustas.com/free-donut/ } # legacy

  data << %w{ http://brianustas.com/cubecraft/  200 }
  data << %w{ http://brianustas.com/cubecraft   301 200 http://brianustas.com/cubecraft/ }

  data << %w{ http://brianustas.com/office-snake/ 301 200 http://officesnake.com }
  data << %w{ http://brianustas.com/office-snake  301 200 http://officesnake.com }
  data << %w{ http://brianustas.com/officesnake/  301 200 http://officesnake.com } # legacy
  data << %w{ http://brianustas.com/officesnake   301 200 http://officesnake.com } # legacy

  data << %w{ http://brianustas.com/robots.txt 200 }
  data << %w{ http://brianustas.com/keybase.txt 200 }
  data << %w{ http://brianustas.com/brian_ustas_resume.pdf 200 }

  data.sort.map do |d|
    ret = {
      url: d[0],
      http_codes: d[1..-1],
    }

    # Was a redirect URL provided?
    if (/^http:/ =~ d.last) == 0
      ret[:final_redirect_url] = ret[:http_codes].pop
    end

    ret
  end
end

def run_url_test(test)
  res = `curl --silent --head --location #{test[:url]}`

  http_codes = res.scan(/^HTTP\/.+(\d\d\d).+$/).flatten
  final_redirect_url = res.scan(/^Location: (\S*)\s*$/).flatten.last

  http_codes == test[:http_codes] && final_redirect_url == test[:final_redirect_url]
end

def run_all_url_tests
  failed_urls = []
  all_test_data = build_url_test_data

  all_test_data.each do |test|
    puts "Requesting: #{test[:url]}"
    puts "Expected code(s): #{test[:http_codes].join(', ')}"
    puts "Expected final redirect URL: #{test[:final_redirect_url]}" if test[:final_redirect_url]

    if run_url_test(test)
      puts "==> Success!"
    else
      puts "==> Failed!"
      failed_urls << test[:url]
    end

    puts "\n"
  end

  if failed_urls.any?
    puts "Dang! #{failed_urls.count} URL(s) didn't behave properly:"
    failed_urls.each { |url| puts url }
  else
    puts "Success! All #{all_test_data.count} URLs behave correctly."
  end
end

run_all_url_tests
