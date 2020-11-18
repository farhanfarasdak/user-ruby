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

    def initialize(params = {})
      # Default is set to telolet kube staging
      @host = params[:host]
      @user = params[:username]
      @pass = params[:password]
      @source = params[:source]
      @hostname = params[:hostname]

      @http_client = Faraday.new(url: @host) do |conn|
        conn.request    :retry, max: 3, interval: 0.05,
                                interval_randomness: 0.5, backoff_factor: 2
        conn.adapter    Faraday.default_adapter
        conn.basic_auth @user, @pass

      end
    end


    PATH = {
      get_user_by_id: '/_internal/users/id/',
    }

    def get_user_by_id(user_id, options = {})
      url = @url + PATH[:get_user_by_id] + user_id.to_s
      get_data(url)
    end


    private

    def get_data(path)
      begin
        @http_client.get do |req|
          req.url path
          req.headers['Content-Type'] = 'application/json'
          req.headers['BL-Service'] = @source
          req.headers['Host'] = @hostname
        end
      rescue StandardError => e
        # TODO: log here
        raise e
      end
    end
  end
end
