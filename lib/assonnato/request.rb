#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Assonnato
  module Request
    def get(host, base_path, path)
      uri = URI.parse "#{host}#{base_path}#{path}"
      request :get, uri
    end

    def post(host, base_path, path, params = {})
      uri = URI.parse "#{host}#{base_path}#{path}"
      request :post, uri, params
    end

    private
    def request(method, url, params = {})
      uri = URI url
      ssl = uri.scheme == 'https'

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: ssl) do |http|
        request = case method.to_sym
          when :get
            Net::HTTP::Get.new uri
          when :post
            Net::HTTP.post_form uri, params
          else
            raise ArgumentError, 'format not recognized'
        end
        response = http.request request
        raise ResourceNotFound unless response.body
        response.body
      end
    end
  end
end