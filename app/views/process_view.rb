class ProcessView < UITableViewCell
  include BW::KVO

  attr_accessor :process, :type, :count

  def init
    initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"PROCESS").tap do
      textLabel.textColor = 0x20404B.uicolor
      textLabel.backgroundColor = :clear.uicolor
      self.contentView.backgroundColor = :clear.uicolor
      bg_view = UIView.alloc.init
      bg_view.setBackgroundColor 0xD3C7B9.uicolor
      setSelectedBackgroundView bg_view
      observe(self, :process) do |_, new_ps|
        textLabel.text     = new_ps.type.to_s
        accessoryView.text = new_ps.count.to_s
      end

      set_count_view

      on_tap do |gesture|
        UIActionSheet.alert "Restart #{@process.type} process?", buttons: ['Cancel', 'Restart Process'],
          cancel: proc { },
          destructive: proc { restart_app }
      end
    end
  end

  def set_count_view
    @count_label = UILabel.alloc.initWithFrame(CGRectMake(0, 0, 16, 16))
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
    @ps_count = UILabel.alloc.initWithFrame [[265, 8], [26, 26]]
    @ps_count.text = @process.count.to_s
    @ps_count.textAlignment = UITextAlignmentCenter
    @ps_count.backgroundColor = :clear.uicolor
    self.contentView.addSubview @ps_count
  end
end
