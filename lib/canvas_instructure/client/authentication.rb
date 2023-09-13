# frozen_string_literal: true

module CanvasInstructure
  class Client
    module Authentication           
      def authorization_url(redirect_uri, state=nil)
        params = {
          client_id: @client_id,
          response_type: 'code',
          state: state,
          redirect_uri: redirect_uri
        }
        "#{host}/login/oauth2/auth?#{URI.encode_www_form(params)}"
      end

      def exchange_code_for_token(code, redirect_uri)
        params = {
          grant_type: 'authorization_code',
          client_id: client_id,
          client_secret: client_secret,
          redirect_uri: redirect_uri,
          code: code
        }
        response = HTTParty.post("#{host}/login/oauth2/token", body: params)
        @access_token = response['access_token']
        @refresh_token = response['refresh_token']

        { access_token: @access_token, refresh_token: @refresh_token }
      end

      def authenticated_get(path)
        headers = {
          'Authorization' => "Bearer #{@access_token}"
        }
        HTTParty.get("#{host}/#{path}", headers: headers)
      end

      def refresh_access_token
        params = {
          grant_type: 'refresh_token',
          client_id: client_id,
          client_secret: client_secret,
          refresh_token: refresh_token
        }
        response = HTTParty.post("#{host}/login/oauth2/token", body: params)
        @access_token = response['access_token']
      end
    end
  end
end