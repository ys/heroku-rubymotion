class Addon
  ADDON_PROPERTIES = [:attachable,
                      :attachment_name,
                      :beta,
                      :configured,
                      :consumes_dyno_hours,
                      :description,
                      :group_description,
                      :name,
                      :plan_description,
                      :price,
                      :selective,
                      :slug,
                      :sso_url,
                      :state,
                      :terms_of_service,
                      :url]

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


