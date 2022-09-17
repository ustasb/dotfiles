# Script for testing my internet links.
# Relies on curl: https://curl.haxx.se/
# Usage: `test_brians_internet_links.rb`

def build_url_test_data
  data = []

  # format: [<test-url> <...expected-http-codes> <expected-final-redirect-url>?]

  # hub3.com
  data << %w{ http://hub3.com      301 200 https://hub3.com/ }
  data << %w{ http://www.hub3.com  301 301 200 https://hub3.com/ }
  data << %w{ https://hub3.com     200 }
  data << %w{ https://www.hub3.com 301 200 https://hub3.com/ }

  # hub3.co
  data << %w{ http://hub3.co      301 301 200 https://hub3.com/ }
  data << %w{ http://www.hub3.co  301 301 200 https://hub3.com/ }
  data << %w{ https://hub3.co     301 200 https://hub3.com/ }
  data << %w{ https://www.hub3.co 301 200 https://hub3.com/ }

  # hub3solutions.com
  data << %w{ http://hub3solutions.com      301 301 200 https://hub3.com/ }
  data << %w{ http://www.hub3solutions.com  301 301 200 https://hub3.com/ }
  data << %w{ https://hub3solutions.com     301 200 https://hub3.com/ }
  data << %w{ https://www.hub3solutions.com 301 200 https://hub3.com/ }

  # hub3.solutions
  data << %w{ http://hub3.solutions      301 301 200 https://hub3.com/ }
  data << %w{ http://www.hub3.solutions  301 301 200 https://hub3.com/ }
  data << %w{ https://hub3.solutions     301 200 https://hub3.com/ }
  data << %w{ https://www.hub3.solutions 301 200 https://hub3.com/ }

  # officesnake.com
  data << %w{ http://officesnake.com      301 200 https://officesnake.com/ }
  data << %w{ http://www.officesnake.com  301 200 https://officesnake.com/ }
  data << %w{ https://officesnake.com     200 }
  data << %w{ https://www.officesnake.com 301 200 https://officesnake.com/ }

  # pandify.com
  data << %w{ http://pandify.com      301 200 https://pandify.com/ }
  data << %w{ http://www.pandify.com  301 200 https://pandify.com/ }
  data << %w{ https://pandify.com     200 }
  data << %w{ https://www.pandify.com 301 200 https://pandify.com/ }

  # hitpic.me
  data << %w{ http://hitpic.me      301 200 https://hitpic.me/ }
  data << %w{ http://www.hitpic.me  301 200 https://hitpic.me/ }
  data << %w{ https://hitpic.me     200 }
  data << %w{ https://www.hitpic.me 301 200 https://hitpic.me/ }

  # ustasb.com
  data << %w{ http://ustasb.com      301 200 https://brianustas.com/ }
  data << %w{ http://www.ustasb.com  301 200 https://brianustas.com/ }
  data << %w{ https://ustasb.com     301 200 https://brianustas.com/ }
  data << %w{ https://www.ustasb.com 301 200 https://brianustas.com/ }

  # brianustas.com
  data << %w{ http://brianustas.com      301 200 https://brianustas.com/ }
  data << %w{ http://www.brianustas.com  301 200 https://brianustas.com/ }
  data << %w{ https://brianustas.com     200 }
  data << %w{ https://www.brianustas.com 301 200 https://brianustas.com/ }

  data << %w{ https://brianustas.com/knightly-dashboard-demo/  200 }
  data << %w{ https://brianustas.com/knightly-dashboard-demo   301 200 https://brianustas.com/knightly-dashboard-demo/ }
  data << %w{ https://brianustas.com/knightly-demo/            301 200 https://brianustas.com/knightly-dashboard-demo/ } # legacy
  data << %w{ https://brianustas.com/knightly-demo             301 200 https://brianustas.com/knightly-dashboard-demo/ } # legacy
  data << %w{ https://brianustas.com/campus-safety-dashboard/  301 200 https://brianustas.com/knightly-dashboard-demo/ } # legacy
  data << %w{ https://brianustas.com/campus-safety-dashboard   301 200 https://brianustas.com/knightly-dashboard-demo/ } # legacy

  data << %w{ https://brianustas.com/where-in-the-world/ 200 }
  data << %w{ https://brianustas.com/where-in-the-world  301 200 https://brianustas.com/where-in-the-world/ }
  data << %w{ https://brianustas.com/whereintheworld/    301 200 https://brianustas.com/where-in-the-world/ } # legacy
  data << %w{ https://brianustas.com/whereintheworld     301 200 https://brianustas.com/where-in-the-world/ } # legacy

  data << %w{ https://brianustas.com/emoji-soup/ 200 }
  data << %w{ https://brianustas.com/emoji-soup  301 200 https://brianustas.com/emoji-soup/ }
  data << %w{ https://brianustas.com/emojisoup/  301 200 https://brianustas.com/emoji-soup/ } # legacy
  data << %w{ https://brianustas.com/emojisoup   301 200 https://brianustas.com/emoji-soup/ } # legacy

  data << %w{ https://brianustas.com/dunkin-donuts-auto-survey/ 200 }
  data << %w{ https://brianustas.com/dunkin-donuts-auto-survey  301 200 https://brianustas.com/dunkin-donuts-auto-survey/ }
  data << %w{ https://brianustas.com/free-donut/                301 200 https://brianustas.com/dunkin-donuts-auto-survey/ } # legacy
  data << %w{ https://brianustas.com/free-donut                 301 200 https://brianustas.com/dunkin-donuts-auto-survey/ } # legacy
  data << %w{ https://brianustas.com/freedonut/                 301 200 https://brianustas.com/dunkin-donuts-auto-survey/ } # legacy
  data << %w{ https://brianustas.com/freedonut                  301 200 https://brianustas.com/dunkin-donuts-auto-survey/ } # legacy

  data << %w{ https://brianustas.com/cubecraft/  200 }
  data << %w{ https://brianustas.com/cubecraft   301 200 https://brianustas.com/cubecraft/ }

  data << %w{ https://brianustas.com/infinite-jest-music/  200 }
  data << %w{ https://brianustas.com/infinite-jest-music   301 200 https://brianustas.com/infinite-jest-music/ }

  data << %w{ https://brianustas.com/office-snake/ 301 200 https://officesnake.com }
  data << %w{ https://brianustas.com/office-snake  301 200 https://officesnake.com }
  data << %w{ https://brianustas.com/officesnake/  301 200 https://officesnake.com } # legacy
  data << %w{ https://brianustas.com/officesnake   301 200 https://officesnake.com } # legacy

  data << %w{ https://brianustas.com/sitemap.xml 200 }
  data << %w{ https://brianustas.com/robots.txt 200 }
  data << %w{ https://brianustas.com/keybase.txt 200 }
  data << %w{ https://brianustas.com/portfolio 301 200 https://brianustas.com/blog }

  data.sort.map do |d|
    ret = {
      url: d[0],
      http_codes: d[1..-1],
    }

    # Was a redirect URL provided?
    if (/^https?:/ =~ d.last) == 0
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
