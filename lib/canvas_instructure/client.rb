require 'httparty'
require 'canvas_instructure/api_resource/resource'
require 'canvas_instructure/client/authentication'
require 'canvas_instructure/api_resource/user'
require 'canvas_instructure/client/users'
require 'canvas_instructure/api_resource/enrollment'
require 'canvas_instructure/client/enrollments'
require 'canvas_instructure/api_resource/group'
require 'canvas_instructure/client/groups'
require 'canvas_instructure/api_resource/course'
require 'canvas_instructure/client/courses'
require 'canvas_instructure/api_resource/module'
require 'canvas_instructure/client/modules'

module CanvasInstructure
  class ApiResponseError < StandardError; end
  class Client
    include HTTParty
    include Authentication
    include Users
    include Enrollments
    include Groups
    include Modules
    include Courses

    attr_accessor :client_id, :client_secret, :access_token, :token_storage
    attr_reader :host

     def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    def host=(value)
      @host = value
      set_base_uri
    end

    def init!
      self
    end

# "1ef7a484f8e4e76ed9c0c7bc6af1b08ef5cb045f"
    def request(resource = nil)
      parsed_response = JSON.parse(yield)
      if parsed_response.is_a?(Hash) && parsed_response['errors']
        if parsed_response['errors'].first['message'] == "Invalid access token."
          # should refresh token
          refresh_access_token
        end
        raise(ApiResponseError, "#{parsed_response['errors']}")
      end

      return parsed_response.map{ |item| resource.new(item) } if parsed_response.is_a?(Array) && resource
      return resource.new(parsed_response) if resource

      parsed_response
    end

    private

    def set_base_uri
      self.class.base_uri host
    end
  end
end
