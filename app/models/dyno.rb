class Dyno
  PS_PROPERTIES = [:id,
                   :name,
                   :action,
                   :app_name,
                   :attach_url,
                   :command,
                   :created_at,
                   :release_version,
                   :size,
                   :state,
                   :type,
                   :updated_at]

  PS_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opts = nil)
    opts ||= {}
    # Release is reserved word in Obj-C
    opts.delete('release')
    setValuesForKeysWithDictionary(opts)
  end

  def restart(&block)
    Heroku.instance.restart_process(self.app_name, self.type) do |response|
      block.call response
    end
  end

end

