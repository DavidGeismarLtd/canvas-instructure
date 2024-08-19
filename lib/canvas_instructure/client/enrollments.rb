# frozen_string_literal: true

module CanvasInstructure
  class Client
    module Enrollments
      def create_course_enrollment(user_id, course_id, options = {})
        request(ApiResource::Enrollment) do
          self.class.post("/api/v1/courses/#{course_id}/enrollments", {
                            body: options.merge(
                              enrollment: {
                                user_id: user_id, 
                                type: "StudentEnrollment"
                              }
                            ).to_json,
                            headers: {
                              'Content-Type' => 'application/json'
                            }
                          }).body
        end
      end

      def delete_course_enrollment(course_id, enrollment_id)
          self.class.delete("/api/v1/courses/#{course_id}/enrollments/#{enrollment_id}", {
                            headers: {
                              'Content-Type' => 'application/json'
                            }
                          }).body
      end

      def create_section_enrollment(user_id, section_id, options = {})
        request(ApiResource::Enrollment) do
          self.class.post("/api/v1/sections/#{section_id}/enrollments", {
                            body: options.merge(
                              enrollment: {
                                user_id: user_id, 
                                type: "StudentEnrollment"
                              }
                            ).to_json,
                            headers: {
                              'Content-Type' => 'application/json'
                            }
                          }).body
        end
      end

      def delete_section_enrollment(section_id, enrollment_id)
          self.class.delete("/api/v1/sections/#{section_id}/enrollments/#{enrollment_id}", {
                            headers: {
                              'Content-Type' => 'application/json'
                            }
                          }).body
      end 

      def retrieve_enrollment(account_id, enrollment_id, options={})
        request(ApiResource::Enrollment) do
          
         self.class.get("/api/v1/accounts/#{account_id}/enrollments/#{enrollment_id}", {
                                     query: options,
                                     headers: {
                                       'Content-Type' => 'application/json'
                                     }
                                   }).body
         end
      end
    end
  end
end
