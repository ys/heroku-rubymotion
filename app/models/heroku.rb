class Heroku

  HEROKU_API = "https://api.heroku.com"

  def self.instance
    @@heroku ||= new
  end

  def login(username, password, &block)
    body = { username: username, password: password }
    BW::HTTP.post("#{HEROKU_API}/login", { headers: json_headers, payload: body }) do |response|
      block.call(HerokuResponse.new(response)) if block
    end
  end

  def applications(&block)
    authorized_call("/apps", &block)
  end

  def application(name, &block)
    authorized_call("/apps/#{name}", &block)
  end

  def collaborators(application_name, &block)
    authorized_call("/apps/#{application_name}/collaborators", &block)
  end

  def delete_collaborator(application_name, email, &block)
    authorized_delete("/apps/#{application_name}/collaborators/#{email}", &block)
  end

  def dynos(application_name, &block)
    authorized_call("/apps/#{application_name}/dynos", &block)
  end

  def formation(application_name, &block)
    authorized_call("/apps/#{application_name}/formation", &block)
  end

  def addons(application_name, &block)
    authorized_call("/apps/#{application_name}/addons", &block)
  end

  def config(application_name, &block)
    authorized_call("/apps/#{application_name}/config-vars", &block)
  end

  def update_config(application_name, key, value, &block)
    body = {key => value}
    authorized_patch("/apps/#{application_name}/config-vars", body, &block)
  end

  def restart_dyno(application_name, dyno_type, &block)
    body = {}
    authorized_delete("/apps/#{application_name}/dynos/#{dyno_type}", &block)
  end

  def scale_dyno(application_name, dyno_type, quantity, &block)
    body = { quantity: quantity }
    authorized_patch("/apps/#{application_name}/formation/#{dyno_type}", body, &block)
  end

  def restart(application_name, &block)
    authorized_delete("/apps/#{application_name}/dynos", &block)
  end

  def authorized_call(path, &block)
    BW::HTTP.get("#{HEROKU_API}#{path}", { headers: authorization_headers }) do |response|
      block.call(HerokuResponse.new(response)) if block
    end
  end

  def authorized_post(path, &block)
    BW::HTTP.post("#{HEROKU_API}#{path}", { headers: authorization_headers }) do |response|
      block.call(HerokuResponse.new(response)) if block
    end
  end

  def authorized_put(path, body, &block)
    BW::HTTP.put("#{HEROKU_API}#{path}", { payload: body , headers: authorization_headers }) do |response|
      block.call(HerokuResponse.new(response)) if block
    end
  end

  def authorized_patch(path, body, &block)
    BW::HTTP.patch("#{HEROKU_API}#{path}", { payload: BW::JSON.generate(body), headers: authorization_headers }) do |response|
      block.call(HerokuResponse.new(response)) if block
    end
  end

  def authorized_delete(path, &block)
    BW::HTTP.delete("#{HEROKU_API}#{path}", { headers: authorization_headers }) do |response|
      block.call(HerokuResponse.new(response)) if block
    end
  end

  def authorization_headers
    user_pass = [":#{User.current.api_key}"].pack("m").gsub("\n", '')
    headers.merge({ "Authorization" => "Basic #{user_pass}"})
  end

  def json_headers
    {
      "Accept" => "application/json",
    }
  end

  def headers
    {
      "Accept"       => "application/vnd.heroku+json; version=3",
      "Content-type" => "application/json",
    }
  end
end
