require './lib/http'

urls = [
  'https://www.greglangford.co.uk/',
  'https://www.greglangford.co.uk/docker-compose-unable-to-connect-to-port/',
  'https://www.greglangford.co.uk/cross-compile-ruby-orange-pi-zero/',
  'https://www.greglangford.co.uk/lezyne-deca-drive-1500xxl-battery/',
  'https://www.greglangford.co.uk/stm8-8-bit-timer-configuration/',
  'https://www.greglangford.co.uk/category/programming/',
]

http_requester = HTTP::Requester.new('greglangford.co.uk', 443, :use_ssl => true, :useragent => 'RubyBot https://github.com/greglangford/ruby-streaming-http-requester')

http_requester.get_multiple urls do |url, response|
  puts "Processing URL: #{url}"

  StringIO.open do |io|
    # Read the response body in chunks
    response.read_body do |chunk|

      # Limit size of response
      if io.size > 100000
        puts "error, size too large"
      end

      # Write chunk to buffer
      io.write chunk
    end

    # Print whole response body
    puts io.string

    # Close buffer
    io.close
  end
end
