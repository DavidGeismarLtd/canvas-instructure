# frozen_string_literal: true

module CanvasInstructure
  class Client
    module Users
      # https://canvas.instructure.com/doc/api/users.html#method.users.create
      def create_user(account_id, options = {})
        request(ApiResource::User) do
          self.class.post("/api/v1/accounts/#{account_id}/users", {
                            body: options.to_json,
                            headers: {
                              'Authorization' => "Bearer #{api_access_token}",
                              'Content-Type' => 'application/json'
                            }
                          }).body
        end
      end

      def list_users(account_id, search_term = nil)
        request(ApiResource::User) do
          self.class.get("/api/v1/accounts/#{account_id}/users", {
                           query: { search_term: search_term },
                           headers: {
                             'Authorization' => "Bearer #{api_access_token}",
                             'Content-Type' => 'application/json'
                           }
                         }).body
        end
      end

      def get_user(id)
       request(ApiResource::User) do
         self.class.get("/api/v1/users/#{id}", {
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
