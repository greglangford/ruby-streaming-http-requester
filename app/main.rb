require './lib/http'

urls = [
  'http://www.greglangford.co.uk',
  'https://www.greglangford.co.uk'
]

connections = {}

urls.each do |url|
  uri = URI(url)

  if not connections.has_key? uri.host.to_sym
    connections[uri.host.to_sym] = {}
  end

  if not connections[uri.host.to_sym].has_key? uri.port
    connections[uri.host.to_sym][uri.port] = {}
  end

  if not connections[uri.host.to_sym][uri.port].has_key? uri.scheme.to_sym
    connections[uri.host.to_sym][uri.port][uri.scheme.to_sym] = []
  end

  if not connections[uri.host.to_sym][uri.port][uri.scheme.to_sym].include? url
    connections[uri.host.to_sym][uri.port][uri.scheme.to_sym].push url
  end

end

connections.each do |host, ports|
  ports.each do |port, schemes|
    schemes.each do |scheme, urls|
      host    = host.to_s
      use_ssl = (scheme.to_s == "https" ? true : false)

      http_requester = HTTP::Requester.new(host, port, :use_ssl => use_ssl, :useragent => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0')

      http_requester.get_multiple urls do |url, response|
        puts response
      end
    end
  end
end

#http_requester = HTTP::Requester.new('greenfingers.com', 443, :use_ssl => true, :useragent => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0')

#http_requester.get_multiple urls do |url, response|
#  puts "Processing URL: #{url}"
#
#  StringIO.open do |io|
#    # Read the response body in chunks
#    response.read_body do |chunk|
#
#      # Limit size of response
#      if io.size > 100000
#        puts "error, size too large"
#      end
#
#      # Write chunk to buffer
#      io.write chunk
#    end
#
#    # Print whole response body
#    puts io.string
#
#    # Close buffer
#    io.close
#  end
#end
