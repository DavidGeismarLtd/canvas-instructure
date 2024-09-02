# frozen_string_literal: true

module CanvasInstructure
  class Client
    module Courses
      def retrieve_courses
        request(ApiResource::Course) do
         self.class.get("/api/v1/courses", {
                                     query: { "per_page" => 100 },
                                     headers: {
                                       'Authorization' => "Bearer #{api_access_token}",
                                       'Content-Type' => 'application/json'
                                     }
                                   }).body
         end
      end

      def retrieve_active_courses
        request(ApiResource::Course) do
          self.class.get("/api/v1/accounts/#{account_id}/courses", {
                                      query: { "per_page" => 100 },
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
