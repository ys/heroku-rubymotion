class Addon
  ADDON_PROPERTIES = [:name, :description, :url,
                      :beta, :state, :configured, :attachable, :group_description,
                      :sso_url, :plan_description, :terms_of_service, :slug,
                      :price, :consumes_dyno_hours, :selective, :attachment_name]

  ADDON_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opt={})
    setValuesForKeysWithDictionary(opt)
  end

  def full_description
    "#{group_description} #{plan_description}"
  end

end


