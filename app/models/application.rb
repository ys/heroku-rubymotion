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
                    :region,
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
    @collaborators = []
    @collaborators_loaded = false
  end

  def self.all(&block)
    Heroku.instance.applications do |response|
      if response.ok?
        apps = response.json.map do |application_json|
          app = new(application_json)
          app.load_processes {}
          app
        end
        block.call apps
      else
        TempAlert.alert "oops", false
      end
    end
  end

  def restart(&block)
    Heroku.instance.restart(self.name) do |response|
      block.call response
    end
  end

  def load_processes(force = false, &block)
    if force || @processes.empty?
      Heroku.instance.processes(self.name) do |response|
        if response.ok?
          processes = response.json.map do |process_json|
            Process.new(process_json)
          end
          @processes = processes
          @processes_loaded = true
          block.call processes
        else
          TempAlert.alert 'oops', false
          block.call []
        end
      end
    else
      block.call @processes
    end
  end

  def load_addons(force = false, &block)
    if force || @addons.empty?
      Heroku.instance.addons(self.name) do |response|
        if response.ok?
          @addons = response.json.map do |addon_json|
            Addon.new(addon_json)
          end
          @addons_loaded = true
          block.call @addons
        else
          TempAlert.alert 'oops', false
          block.call []
        end
      end
    else
      block.call @addons
    end
  end

  def load_collaborators(force = false, &block)
    if force || @collaborators.empty?
      Heroku.instance.collaborators(self.name) do |response|
        if response.ok?
          @collaborators = response.json.map do |collaborator_json|
            Collaborator.new(collaborator_json)
          end
          @collaborators_loaded = true
          block.call @collaborators
        else
          TempAlert.alert 'oops', false
          block.call []
        end
      end
    else
      block.call @collaborators
    end
  end

  def load_config(force = false, &block)
    if force || @config_vars.empty?
      Heroku.instance.config(self.name) do |response|
        if response.ok?
          @config_vars = []
          response.json.each_pair do |key, value|
            @config_vars << ConfigVar.new(key, value)
          end
          @config_loaded = true
          block.call @config_vars
        else
          TempAlert.alert 'oops', false
          block.call []
        end
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

