# frozen_string_literal: true

module CanvasInstructure
  class Client
    module Sections
      def retrieve_sections(course_id)
        request(ApiResource::Module) do
         self.class.get("/api/v1/courses/#{course_id}/sections", {
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