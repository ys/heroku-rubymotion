class ProcessWithCount < Struct.new(:app_name, :type, :count)
  def restart(&block)
    Heroku.instance.restart_process(app_name, type) do |response|
      block.call response
    end
  end

  def dynos=(value)
    self.count = value
  end

  def update(&block)
    if self.count >= 0
      Heroku.instance.scale_process(self.app_name, self.type, self.count) do |response|
        block.call response
      end
    end
  end
end
