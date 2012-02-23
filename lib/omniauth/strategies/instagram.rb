require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Instagram < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://api.instagram.com',
        :authorize_url => 'https://api.instagram.com/oauth/authorize',
        :token_url => 'https://api.instagram.com/oauth/access_token'
      }

      def request_phase
        options[:scope] ||= 'basic'
        options[:response_type] ||= 'code'
        super
      end

      uid { raw_info['id'] }

      info do
        {
          'nickname' => raw_info['username'],
          'name'     => raw_info['full_name'],
          'image'    => raw_info['profile_picture'],
          'bio'      => raw_info['bio'],
          'website'  => raw_info['website'],
        }
      end
      extra do
        {
          'raw_info' => access_token.params
        }
      end

      def raw_info
        @data ||= access_token.params["user"]
      end
    end
  end
end
