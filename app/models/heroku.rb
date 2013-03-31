class Heroku

  HEROKU_API = "https://api.heroku.com"

  def login(username, password, &block)
    raise StandardError unless username && password && block
    body = { username: username, password: password }
    BW::HTTP.post("#{HEROKU_API}/login", { headers: headers, payload: body }) do |response|
        user_json = BW::JSON.parse response.body
        block.call(user_json)
    end
  end

  def applications(&block)
    authorized_call("/apps", &block)
  end

  def application(name, &block)
    authorized_call("/app/#{name}", &block)
  end

  def authorized_call(path, &block)
    BW::HTTP.get("#{HEROKU_API}#{path}", { headers: authorization_headers }) do |response|
      response_json = BW::JSON.parse response.body
      block.call(response_json)
    end
  end

  def authorization_headers
    user_pass = [":#{User.current.api_key}"].pack("m").gsub("\n", '')
    headers.merge({ "Authorization" => "Basic #{user_pass}"})
  end

  def headers
    {
      "Accept" => "application/json",
    }
  end
end
