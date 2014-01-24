class DynoView < UITableViewCell
  include BW::KVO

  attr_accessor :dyno, :type, :quantity

  def init
    initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"dyno").tap do
      textLabel.textColor = 0x20404B.uicolor
      textLabel.backgroundColor = :clear.uicolor
      self.contentView.backgroundColor = :clear.uicolor
      bg_view = UIView.alloc.init
      bg_view.setBackgroundColor 0xD3C7B9.uicolor
      setSelectedBackgroundView bg_view
      observe(self, :dyno) do |_, new_ps|
        textLabel.text     = new_ps.type.to_s
        accessoryView.text = new_ps.quantity.to_s
      end
      observe(dyno, :count) do |_, new_count|
        accessoryView.text = new_count.to_s
      end

      set_count_view
    end
  end

  def set_count_view
    @count_label = UILabel.alloc.initWithFrame(CGRectMake(0, 0, 16, 16))
    @count_label.textColor = 0x4C6673.uicolor
    @count_label.backgroundColor = :clear.uicolor

    selectionStyle = UITableViewCellSelectionStyleGray
    self.accessoryView = @count_label
  end

  def change_number_of_instances
    @keyboard_view = UIView.alloc.initWithFrame([[0, 460], [320, 260]])  # y: 460, so offscreen, at the bottom.
    nav_bar = UINavigationBar.alloc.initWithFrame([[0, 0], [320, 44]])

    item = UINavigationItem.new
    item.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemCancel,
      target: self,
      action: :cancel)

    item.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemDone,
      target: self,
      action: :done)

    nav_bar.items = [item]  # if you want, play with assigning more items.  I dunno what happens!
    @keyboard_view << nav_bar
    @picker_delegate = self
    @picker_view = UIPickerView.alloc.initWithFrame([[0, 44], [320, 216]])
    @picker_view.showsSelectionIndicator = true
    @picker_view.delegate = @picker_view.dataSource = @picker_delegate
    @picker_view.selectRow(8, inComponent:0, animated:false)
    @keyboard_view << @picker_view
    self.superview << @keyboard_view
    @modal_view.fade_in
    @keyboard_view.slide :up
  end

  def numberOfComponentsInPickerView(picker_view)
    1
  end

  def pickerView(picker_view, numberOfRowsInComponent:section)
    (1..99).to_a.size
  end

  def pickerView(picker_view, titleForRow:row, forComponent:section)
    (1..99).to_a[8].to_s
  end

  def restart_app
  end

  def set_restart_view
    restart_button = UIButton.alloc.initWithFrame [[0, 0], [26, 26]]
    restart_button.setImage UIImage.imageNamed("restart.png"), forState: UIControlStateNormal
    restart_button.on(:touch) do |event|
      restart_app
    end
    self.accessoryView = restart_button
  end

  def set_dyno_count_change_view
    self.accessoryView = nil
    @ps_count = UILabel.alloc.initWithFrame [[265, 8], [26, 26]]
    @ps_count.text = @dyno.count.to_s
    @ps_count.textAlignment = UITextAlignmentCenter
    @ps_count.backgroundColor = :clear.uicolor
    self.contentView.addSubview @ps_count
  end
end
