class Collaborator
  ADDON_PROPERTIES = [:role,
                      :created_at,
                      :updated_at,
                      :id,
                      :user]

  ADDON_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opt={})
    setValuesForKeysWithDictionary(opt)
  end

end



