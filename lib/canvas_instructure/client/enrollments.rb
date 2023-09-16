# frozen_string_literal: true

module CanvasInstructure
  class Client
    module Enrollments
      def create_enrollment(user_id, course_id, options = {})
        request(ApiResource::Enrollment) do
          self.class.post("/api/v1/courses/#{course_id}/enrollments", {
                            body: options.merge(
                              enrollment: {
                                user_id: user_id, 
                                type: "StudentEnrollment"
                              }
                            ).to_json,
                            headers: {
                              'Authorization' => "Bearer #{access_token}",
                              'Content-Type' => 'application/json'
                            }
                          }).body
        end
      end

      def delete_enrollment(course_id, enrollment_id)
          self.class.delete("/api/v1/courses/#{course_id}/enrollments/#{enrollment_id}", {
                            headers: {
                              'Authorization' => "Bearer #{access_token}",
                              'Content-Type' => 'application/json'
                            }
                          }).body
      end

      def retrieve_enrollment(account_id, enrollment_id, options={})
        request(ApiResource::Enrollment) do
          
         self.class.get("/api/v1/accounts/#{account_id}/enrollments/#{enrollment_id}", {
                                     query: options,
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
