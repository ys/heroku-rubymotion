class Application
  APP_PROPERTIES = [:id,
                    :buildpack_provided_description,
                    :create_status,
                    :created_at,
                    :domain_name,
                    :dynos,
                    :git_url,
                    :name,
                    :owner_email,
                    :owner_name,
                    :processes,
                    :released_at,
                    :repo_migrate_status,
                    :repo_size,
                    :requested_stack,
                    :slug_size,
                    :slug_size,
                    :stack,
                    :tier,
                    :updated_at,
                    :web_url,
                    :workers]

  APP_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opt={})
    setValuesForKeysWithDictionary(opt)
    @processes = []
    @processes_loaded = false
    @addons = []
    @addons_loaded = false
    @config_vars = []
    @config_loaded = false
  end

  def self.all(&block)
    Heroku.new.applications do |response|
      apps = response.json.map do |application_json|
        app = new(application_json)
        app.load_processes {}
        app
      end
      block.call apps
    end
  end

  def load_processes(&block)
    unless @processes.any?
      Heroku.new.processes(self.name) do |response|
        processes = response.json.map do |process_json|
          Process.new(process_json)
        end
        @processes = processes
        @processes_loaded = true
        block.call processes
      end
    else
      block.call @processes
    end
  end

  def load_addons(&block)
    unless @addons.any?
      Heroku.new.addons(self.name) do |response|
        @addons = response.json.map do |addon_json|
          Addon.new(addon_json)
        end
        @addons_loaded = true
        block.call @addons
      end
    else
      block.call @addons
    end
  end

  def load_config(&block)
    unless @config_vars.any?
      Heroku.new.config(self.name) do |response|
        @config_vars = []
        response.json.each_pair do |key, value|
          @config_vars << ConfigVar.new(key, value)
        end
        @config_loaded = true
        block.call @config_vars
      end
    else
      block.call @config_vars
    end
  end

  def web_processes
    _processes.select{ |ps| ps.process =~ /^web/ }.size || dynos
  end

  def other_processes
    _processes.select{ |ps| !(ps.process =~ /^web/) }.size || workers
  end

  def process_types
    _processes.map do |ps|
      ps.process.split('.')[0]
    end.uniq
  end

  def process_types_with_count
    processes = process_types.each_with_object({}) do |ps, hsh|
      hsh[ps] = 0
    end
    _processes.each do |ps|
      processes[ps.process.split('.')[0]] += 1
    end
    processes.map { |key, value| ProcessWithCount.new(self.name, key, value) }
  end

  def _processes
    if @processes_loaded == true
      @processes
    else
      load_processes do
      end
      []
    end
  end
end

class ProcessWithCount < Struct.new(:app_name, :type, :count)
  def restart(&block)

    Heroku.new.restart_process(app_name, type) do |result|
      block.call
    end
  end

end
