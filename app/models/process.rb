class Process
  APP_PROPERTIES = [:id, :command, :pretty_state,
                    :process, :size, :state]

  APP_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opt={})
    setValuesForKeysWithDictionary(opt)
  end

end

