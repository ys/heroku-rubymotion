class FormationItem
  PS_PROPERTIES = [:id,
                   :command,
                   :app_name,
                   :created_at,
                   :quantity,
                   :size,
                   :type,
                   :updated_at]

  PS_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opts = nil)
    opts ||= {}
    setValuesForKeysWithDictionary(opts)
  end

  def restart(&block)
    Heroku.instance.restart_dyno(app_name, type) do |response|
      block.call response
    end
  end

  def update(&block)
    if self.quantity >= 0
      Heroku.instance.scale_dyno(self.app_name, self.type, self.quantity) do |response|
        block.call response
      end
    end
  end
end

