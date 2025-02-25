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
require 'canvas_instructure/api_resource/section'
require 'canvas_instructure/client/sections'

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
    include Sections

    attr_accessor :client_id, :client_secret, :access_token, :token_storage, :api_access_token, :account_id
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
      self.class.default_options.merge!(
        query: {
          access_token: api_access_token
        }
      )
      self
    end

    def request(resource = nil)
      max_retries = 2
      retries = 0
    
      begin
        parsed_response = JSON.parse(yield)
        handle_errors(parsed_response)
    
        case parsed_response
        when Array
          handle_array_response(parsed_response, resource)
        when Hash
          handle_hash_response(parsed_response, resource)
        else
          parsed_response
        end
      rescue RuntimeError => e
        if should_retry?(e, retries, max_retries)
          retries += 1
          retry
        else
          raise e
        end
      end
    end

    private

    def handle_errors(response)
      return unless response.is_a?(Hash)

      return unless response['errors'] || response['message']
  
      if response['errors']  
        raise(ApiResponseError, "#{response['errors']}")
      elsif response['message']
        raise(ApiResponseError, "#{response['message']}")
      end
    end

    def handle_array_response(response, resource)
      response.map{ |item| resource.new(item) } if resource
    end

    def handle_hash_response(response, resource)
      resource.new(response) if resource
    end

    def should_retry?(exception, retries, max_retries)
      exception.message == 'Token refreshed. Retrying request.' && retries < max_retries
    end
    
    def set_base_uri
      self.class.base_uri host
    end
  end
end
