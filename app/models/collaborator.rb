class Collaborator
  ADDON_PROPERTIES = [:email,
                      :access,
                      :name,
                      :role]

  ADDON_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opt={})
    setValuesForKeysWithDictionary(opt)
  end

end



