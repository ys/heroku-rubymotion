class Application
  APP_PROPERTIES = [:id, :name, :create_status, :created_at,
                    :stack, :requested_stack,
                    :repo_migrate_status, :slug_size,
                    :repo_size, :dynos, :workers, :processes]

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
    Heroku.new.applications do |applications_json|
      apps = applications_json.map do |application_json|
        app = new({ id:                  application_json["id"],
              name:                application_json["name"],
              create_status:       application_json["create_status"],
              created_at:          application_json["created_at"],
              stack:               application_json["stack"],
              requested_stack:     application_json["requested_stack"],
              repo_migrate_status: application_json["repo_migrate_status"],
              slug_size:           application_json["slug_size"],
              repo_size:           application_json["repo_size"],
              dynos:               application_json["dynos"],
              workers:             application_json["workers"]
        })
        app.load_processes {}
        app
      end
      block.call apps
    end
  end

  def load_processes(&block)
    unless @processes.any?
      Heroku.new.processes(self.name) do |processes_json|
        processes = processes_json.map do |process_json|
          Process.new({
            id:           process_json["id"],
            command:      process_json["command"],
            pretty_state: process_json["pretty_state"],
            process:      process_json["process"],
            size:         process_json["size"],
            state:        process_json["state"],
          })
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
      Heroku.new.addons(self.name) do |addons_json|
        @addons = addons_json.map do |addon_json|
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
      Heroku.new.config(self.name) do |config_vars_json|
        @config_vars = []
        config_vars_json.each_pair do |key, value|
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
    processes.map { |key, value| ProcessWithCount.new(key,value) }
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

class ProcessWithCount < Struct.new(:type, :count); end
