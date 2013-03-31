class User

  USER_PROPERTIES = [:id, :api_key]

  USER_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opt={})
    setValuesForKeysWithDictionary(opt)
  end

  def initWithCoder(decoder)
    USER_PROPERTIES.each do |field|
      key = decoder.decodeObjectForKey(field)
      self.send "#{field}=", key
    end
    self
  end

  # called when saving an object to NSUserDefaults
  def encodeWithCoder(encoder)
    USER_PROPERTIES.each do |field|
      encoder.encodeObject(self.send(field), forKey: field)
    end
  end

  def self.current
    current_user_data = store["current_user"]
    current_user_data ? NSKeyedUnarchiver.unarchiveObjectWithData(current_user_data) : new
  end

  def self.destroy
    store["current_user"] = nil
  end

  def persisted?
    self.id
  end

  def save
    self.id ||= BubbleWrap.create_uuid
    self.class.store['current_user'] = NSKeyedArchiver.archivedDataWithRootObject(self)
  end

  def self.store
    @defaults ||= NSUserDefaults.standardUserDefaults
  end
end

