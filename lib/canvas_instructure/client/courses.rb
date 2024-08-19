# frozen_string_literal: true

module CanvasInstructure
  class Client
    module Courses
      def retrieve_courses
        request(ApiResource::Course) do
         self.class.get("/api/v1/courses", {
                                     headers: {
                                       'Authorization' => "Bearer #{api_access_token}",
                                       'Content-Type' => 'application/json'
                                     }
                                   }).body
         end
      end
    end
  end
end
