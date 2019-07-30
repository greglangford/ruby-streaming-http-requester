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
          uri = URI(url)
          request = Net::HTTP::Get.new(uri)
          request['User-Agent'] = @params[:useragent]

          http.request request do |response|
            yield url, response
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
    def connection
      @http.start(@host, @port, :use_ssl => @params[:use_ssl]) do |http|
        yield http
      end
    end
  end
end
