class Process
  PS_PROPERTIES = [:id,
                   :action,
                   :app_name,
                   :attached,
                   :command,
                   :elapsed,
                   :pretty_state,
                   :process,
                   :release_version,
                   :rendezvous_url,
                   :size,
                   :state,
                   :transitioned_at,
                   :type,
                   :upid]

  PS_PROPERTIES.each do |field|
    attr_accessor field
  end

  def initialize(opts={})
    # Release is reserved word in Obj-C
    opts[:release_version] = opts.delete(:release)
    setValuesForKeysWithDictionary(opts)
  end

  def restart(&block)
    Heroku.new.restart_process(self.app_name, self.type) do |response|
      block.call response
    end
  end

end

