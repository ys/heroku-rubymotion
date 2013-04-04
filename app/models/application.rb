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
  end

  def self.all(&block)
    Heroku.new.applications do |applications_json|
      apps = applications_json.map do |application_json|
        new({ id:                  application_json["id"],
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
        block.call processes
      end
    else
      block.call @processes
    end
  end

  def web_processes
    @processes.any? ? @processes.select{ |ps| ps.process =~ /^web/ }.size : dynos
  end

  def other_processes
    @processes.any? ? @processes.select{ |ps| !(ps.process =~ /^web/) }.size : workers
  end

  def process_types
    @processes.map do |ps|
      ps.process.split('.')[0]
    end.uniq
  end

  def process_types_with_count
    processes = process_types.each_with_object({}) do |ps, hsh|
      hsh[ps] = 0
    end
    @processes.each do |ps|
      processes[ps.process.split('.')[0]] += 1
    end
    processes.map { |key, value| ProcessWithCount.new(key,value) }
  end
end

class ProcessWithCount < Struct.new(:type, :count); end
