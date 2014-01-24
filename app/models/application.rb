class Application
  APP_PROPERTIES = [:id,
                    :buildpack_provided_description,
                    :created_at,
                    :git_url,
                    :maintenance,
                    :name,
                    :owner,
                    :released_at,
                    :repo_size,
                    :region,
                    :slug_size,
                    :stack,
                    :tier,
                    :updated_at,
                    :web_url]

  APP_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opt={})
    setValuesForKeysWithDictionary(opt)
    @dynos = []
    @dynos_loaded = false
    @formation = []
    @formation_loaded = false
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
          app.load_dynos {}
          app
        end
        App::Persistence["apps"] = apps.map(&:name)
        block.call apps.sort_by(&:name)
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

  def load_dynos(force = false, &block)
    if force || @dynos.empty?
      Heroku.instance.dynos(self.name) do |response|
        if response.ok?
          dynos = response.json.map do |dyno_json|
            Dyno.new(dyno_json)
          end
          @dynos = dynos
          @dynos_loaded = true
          block.call dynos
        else
          TempAlert.alert 'oops', false
          block.call []
        end
      end
    else
      block.call @dynos
    end
  end

  def load_formation(force = false, &block)
    if force || @formation.empty?
      Heroku.instance.formation(self.name) do |response|
        if response.ok?
          formation = response.json.map do |f_item_json|
            FormationItem.new(f_item_json.merge({ app_name: self.name }))
          end
          @formation = formation
          @formation_loaded = true
          block.call formation
        else
          TempAlert.alert 'oops', false
          block.call []
        end
      end
    else
      block.call @formation
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

  def update_config(config, &block)
    Heroku.instance.update_config(self.name, config.key, config.value) do |response|
      block.call response
    end
  end

  def delete_collaborator(collaborator, &block)
    Heroku.instance.delete_collaborator(self.name, collaborator.email) do |response|
      block.call response
    end
  end

  def web_dynos
    if _dynos.any?
      _dynos.select{ |ps| ps.name =~ /^web/ }.size
    else
      0
    end
  end

  def other_dynos
    if _dynos.any?
      _dynos.select{ |ps| !(ps.name =~ /^web/) }.size
    else
      0
    end
  end

  def dyno_types
    _dynos.map do |ps|
      ps.name.split('.')[0]
    end.uniq
  end

  def _dynos
    if @dynos_loaded == true
      @dynos
    else
      load_dynos do
      end
      []
    end
  end
end

