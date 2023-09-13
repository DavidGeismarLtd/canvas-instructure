# frozen_string_literal: true

module CanvasInstructure
  class Client
    module Groups
      def register_users_to_group(group_id, user_id)
        request(ApiResource::User) do
          self.class.post("/api/v1/groups/#{group_id}/memberships", {
                            body:{ user_id: user_id }.to_json,
                            headers: {
                              'Authorization' => "Bearer #{access_token}",
                              'Content-Type' => 'application/json'
                            }
                          }).body
        end
      end

      def unregister_user_to_group(group_id, membership_id)
        self.class.delete("/api/v1/groups/#{group_id}/memberships/#{membership_id}", {
          headers: {
            'Authorization' => "Bearer #{access_token}",
            'Content-Type' => 'application/json'
          }
        }).body
      end

      def retrieve_groups
        request(ApiResource::Group) do
         self.class.get("/api/v1/users/self/groups", {
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
