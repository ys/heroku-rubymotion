class Application
  APP_PROPERTIES = [:id, :name, :create_status, :created_at,
                    :stack, :requested_stack,
                    :repo_migrate_status, :slug_size, :repo_size, :dynos, :workers]

  APP_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opt={})
    setValuesForKeysWithDictionary(opt)
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
end
