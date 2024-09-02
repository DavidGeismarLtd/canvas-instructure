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
        all_courses = []
        page = 1
        loop do
          response = self.class.get("/api/v1/accounts/#{account_id}/courses", {
            query: { "per_page" => 100, "page" => page },
            headers: {
              'Authorization' => "Bearer #{api_access_token}",
              'Content-Type' => 'application/json'
            }
          })
          courses = request(ApiResource::Course) do
            response.body
          end
          all_courses.concat(courses)

          # Debugging output
          puts "Page: #{page}, Retrieved Courses: #{courses.size}"
          puts "Link Header: #{response.headers['link']}"
           # Check for next page link
          link_header = response.headers['link']
          break unless link_header && link_header.include?('rel="next"')

          # If there's a next page, extract the page number (optional)
          next_page_link = link_header.match(/<([^>]+)>;\s*rel="next"/)
          next_page_url = next_page_link[1] if next_page_link
          page += 1
        end
        all_courses
      end
    end
  end
end