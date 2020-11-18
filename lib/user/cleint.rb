module User
  class Client
    include HTTParty
    format :json

    def initialize(
      url = nil,
      username = nil,
      password = nil,
      source = nil,
      hostname = nil
    )
      @url =  url
      @username = username
      @password = password
      @source = source
      @hostname = hostname
    end

    PATH = {
      get_user_by_id: '/_internal/users/id/',
    }

    def get_user_by_id(user_id, options = {})
      url = @url + PATH[:email] + user_id.to_s
      auth = {
        username: @username,
        password: @password
      }

      params = {
        headers: {
          content_type: :json,
          accept: :json
          host: @hostname,
          "BL-Service": @source
        },
        basic_auth: auth
      }
      begin
        HTTParty.get(url, params)
      rescue StandardError => e
        # TODO: log here
        raise e
      end
    end

  end
end
