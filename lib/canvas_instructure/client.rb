require 'httparty'
require 'canvas_instructure/client/authentication'

module CanvasInstructure
  class Client
    include HTTParty
    include CanvasInstructure::Client::Authentication
    attr_accessor :client_id, :client_secret, :host, :access_token

     def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    def init!
      self
    end

# "1ef7a484f8e4e76ed9c0c7bc6af1b08ef5cb045f"
    def request(resource = nil)
      parsed_response = JSON.parse(yield)
      if parsed_response.is_a?(Hash) && parsed_response['error']
        # handle errors
        # case parsed_response['error']
        # when "expired_token"
        #   raise(ExpiredTokenError, "#{parsed_response['error']} - #{parsed_response['error_description']}")
        # else
        #   raise(ApiResponseError, "#{parsed_response['error']} - #{parsed_response['error_description']}")
        # end
      end
      return parsed_response.map{ |item| resource.new(item) } if parsed_response.is_a?(Array) && resource
      return resource.new(parsed_response) if resource

      parsed_response

    # food for thoughs
    # rescue ::RiseUp::ExpiredTokenError => e
    #   account.global_config.update(rise_up_access_token_details: nil)
    #   token_details = authenticate
    #   account.global_config.update(
    #     rise_up_access_token_details: token_details
    #   )
    #   self.access_token_details = account.global_config.rise_up_access_token_details
    #   self.access_token = account.global_config.rise_up_access_token_details['access_token']
    #   @retries = @retries ? @retries + 1 : 1
    #   @retries > RETRY_LIMIT ? raise(e) : retry
    end
  end
end
