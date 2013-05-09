class ProcessView < UITableViewCell

  attr_accessor :process

  def initialize(ps)
    initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"PROCESS").tap do
      @process = ps
      textLabel.text = @process.type
      textLabel.textColor = 0x20404B.uicolor
      textLabel.backgroundColor = :clear.uicolor
      self.contentView.backgroundColor = :clear.uicolor

      set_count_view

      #on_swipe :left do |gesture|
      #  set_restart_view
      #end

      #on_swipe :right do |gesture|
      #  set_process_count_change_view
      #end
      on_tap do |gesture|
        UIActionSheet.alert "Restart #{@process.type} process?", buttons: ['Cancel', 'Restart Process'],
          cancel: proc { },
          destructive: proc { restart_app }
      end
    end
  end

  def set_count_view
    @count_label = UILabel.alloc.initWithFrame(CGRectMake(0, 0, 16, 16))
    @count_label.text = @process.count.to_s
    @count_label.textColor = 0x4C6673.uicolor
    @count_label.backgroundColor = :clear.uicolor

    selectionStyle = UITableViewCellSelectionStyleGray
    self.accessoryView = @count_label
  end

  def restart_app
    @process.restart do |response|
      if response.ok?
        set_count_view
        TempAlert.alert "Restarted", true
      else
        TempAlert.alert "oops", false
      end
    end
  end

  def set_restart_view
    restart_button = UIButton.alloc.initWithFrame [[0, 0], [26, 26]]
    restart_button.setImage UIImage.imageNamed("restart.png"), forState: UIControlStateNormal
    restart_button.on(:touch) do |event|
      restart_app
    end
    self.accessoryView = restart_button
  end

  def set_process_count_change_view
    self.accessoryView = nil
    @add_button = UIButton.alloc.initWithFrame [[290, 8], [26, 26]]
    @add_button.setImage UIImage.imageNamed("plus.png"), forState: UIControlStateNormal
    @remove_button = UIButton.alloc.initWithFrame [[240, 8], [26, 26]]
    @remove_button.setImage UIImage.imageNamed("minus.png"), forState: UIControlStateNormal
    @ps_count = UILabel.alloc.initWithFrame [[265, 8], [26, 26]]
    @ps_count.text = @process.count.to_s
    @ps_count.textAlignment = UITextAlignmentCenter
    @ps_count.backgroundColor = :clear.uicolor
    self.contentView.addSubview @ps_count
    self.contentView.addSubview(@add_button)
    self.contentView.addSubview(@remove_button)


    @remove_button.on_tap do
      @process.count -= 1 unless @process.count == 0
      @ps_count.text = @process.count.to_s
    end

    @add_button.on_tap do
      @process.count += 1 unless @process.count == 99
      @ps_count.text = @process.count.to_s
    end
  end
end
