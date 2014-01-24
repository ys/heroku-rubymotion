class Addon
  ADDON_PROPERTIES = [:name,
                      :created_at,
                      :id,
                      :description,
                      :name,
                      :price,
                      :plan,
                      :state,
                      :updated_at]

  ADDON_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opts={})
    setValuesForKeysWithDictionary(opts)
  end

  def full_description
    plan['name']
  end

end


