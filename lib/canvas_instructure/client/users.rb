# frozen_string_literal: true

module CanvasInstructure
  class Client
    module Users
      # https://canvas.instructure.com/doc/api/users.html#method.users.create
      def create_user(account_id, options = {})
        request(ApiResource::User) do
          self.class.post("/api/v1/accounts/#{account_id}/users", {
                            body: options.merge(username:).to_json,
                            headers: {
                              'Authorization' => "Bearer #{access_token}",
                              'Content-Type' => 'application/json'
                            }
                          }).body
        end
      end

      def get_user(id)
       request(ApiResource::User) do
         self.class.get("/api/v1/users/#{id}", {
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
