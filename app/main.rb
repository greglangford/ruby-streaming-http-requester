require './lib/http'

urls = [
  'http://www.greglangford.co.uk',
]

http_requester = HTTP::Requester.new('greglangford.co.uk', 80, :use_ssl => false, :useragent => 'RubyBot https://github.com/greglangford/ruby-streaming-http-requester')

http_requester.get_multiple urls do |url, response|

  puts url

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
    #puts io.string

    # Close buffer
    io.close
  end
end
