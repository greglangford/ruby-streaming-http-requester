require 'net/http'
require 'stringio'

module HTTP
  class Requester
    def initialize(host, port, params)
      @http    = Net::HTTP
      @host    = host
      @port    = port
      @params  = params
    end

    def get_multiple(urls)
      connection do |http|
        urls.each do |url|
          request http, url do |uri, response|
            yield uri, response
          end
        end
      end
    end

    def get(url)
      connection do |http|
        uri = URI(url)
        request = Net::HTTP::Get.new(uri)
        request['User-Agent'] = @params[:useragent]

        http.request request do |response|
          yield response
        end
      end
    end

    private
    # need to pass variables to this method
    # it will be reused to follow redirects
    def connection
      @http.start(@host, @port, :use_ssl => @params[:use_ssl]) do |http|
        yield http
      end
    end

    def request(http, url)
      response_is_not_redirect = false

      until response_is_not_redirect do
        uri = URI(url)
        request = Net::HTTP::Get.new(uri)
        request['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36'

        http.request request do |response|
          case response
          when Net::HTTPRedirection then
            # If redirect is to different scheme and port, new connection is needed.
            # I wonder if we can start a new connection here and return that response?
            location = response['location']
            uri = URI(location)

            puts uri.to_s

            puts "making new request"

            @http.start(uri.host, uri.port, :use_ssl => true) do |http|
              uri = URI(url)
              request = Net::HTTP::Get.new(uri)
              request['User-Agent'] = @params[:useragent]

              http.request request do |response|
                response_is_not_redirect = true
                yield uri, response
              end
            end
          else
            response_is_not_redirect = true
            yield uri, response
          end
        end
      end
    end
  end
end
