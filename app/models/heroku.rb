class Heroku

  HEROKU_API = "https://api.heroku.com"

  def self.instance
    @@heroku ||= new
  end

  def login(username, password, &block)
    body = { username: username, password: password }
    BW::HTTP.post("#{HEROKU_API}/login", { headers: headers, payload: body }) do |response|
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

  def processes(application_name, &block)
    authorized_call("/apps/#{application_name}/ps", &block)
  end

  def addons(application_name, &block)
    authorized_call("/apps/#{application_name}/addons", &block)
  end

  def config(application_name, &block)
    authorized_call("/apps/#{application_name}/config_vars", &block)
  end

  def update_config(application_name, key, value, &block)
    body = BW::JSON.generate({key => value})
    authorized_put("/apps/#{application_name}/config_vars", body, &block)
  end

  def restart_process(application_name, process_type, &block)
    authorized_post("/apps/#{application_name}/ps/restart?type=#{process_type}", &block)
  end

  def scale_process(application_name, process_type, quantity, &block)
    authorized_post("/apps/#{application_name}/ps/scale?type=#{process_type}&qty=#{quantity}", &block)
  end

  def restart(application_name, &block)
    authorized_post("/apps/#{application_name}/ps/restart", &block)
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

  def authorized_delete(path &block)
    BW::HTTP.delete("#{HEROKU_API}#{path}", { headers: authorization_headers }) do |response|
      block.call(HerokuResponse.new(response)) if block
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
