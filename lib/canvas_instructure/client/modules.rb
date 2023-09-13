# frozen_string_literal: true

module RiseUp
  class Client
    module Modules
      def retrieve_modules(course_id)
        request(ApiResource::Module) do
         self.class.get("/api/v1/courses/#{course_id}/modules", {
                                     headers: {
                                       'Authorization' => "Bearer #{access_token}",
                                       'Content-Type' => 'application/json'
                                     }
                                   }).body
         end
      end
    end
  end
end
