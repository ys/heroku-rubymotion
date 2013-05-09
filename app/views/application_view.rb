class ApplicationView < UIView

  attr_accessor :target

  def initialize(app, parent_view)
    initWithFrame(parent_view.bounds).tap do
      web_dynos_label= UILabel.alloc.initWithFrame(CGRectMake(0, 30, 160, 16))
      web_dynos_label.text = "Web"
      web_dynos_label.textColor = 0x20404B.uicolor
      web_dynos_label.backgroundColor = :clear.uicolor
      web_dynos_label.textAlignment = UITextAlignmentCenter
      self.addSubview web_dynos_label

      other_dynos_label= UILabel.alloc.initWithFrame(CGRectMake(160, 30, 160, 16))
      other_dynos_label.text = "Other"
      other_dynos_label.textColor = 0x20404B.uicolor
      other_dynos_label.backgroundColor = :clear.uicolor
      other_dynos_label.textAlignment = UITextAlignmentCenter
      self.addSubview other_dynos_label

      @web_dynos_count_label= UILabel.alloc.initWithFrame(CGRectMake(0, 50, 160, 40))
      @web_dynos_count_label.text = app.web_processes.to_s
      @web_dynos_count_label.textColor = 0x20404B.uicolor
      @web_dynos_count_label.backgroundColor = :clear.uicolor
      @web_dynos_count_label.textAlignment = UITextAlignmentCenter
      @web_dynos_count_label.font = UIFont.systemFontOfSize 40
      self.addSubview @web_dynos_count_label

      @other_dynos_count_label= UILabel.alloc.initWithFrame(CGRectMake(160, 50, 160, 40))
      @other_dynos_count_label.text = app.other_processes.to_s
      @other_dynos_count_label.textColor = 0x20404B.uicolor
      @other_dynos_count_label.backgroundColor = :clear.uicolor
      @other_dynos_count_label.textAlignment = UITextAlignmentCenter
      @other_dynos_count_label.font = UIFont.systemFontOfSize 40
      self.addSubview @other_dynos_count_label

      @restart_button = UIButton.buttonWithType UIButtonTypeRoundedRect
      @restart_button.setTitleColor 0x20404B.uicolor, forState: UIControlStateNormal
      @restart_button.setTitleColor :white.uicolor, forState: UIControlStateHighlighted
      @restart_button.setBackgroundImage "light_pink.png".uiimage, forState: UIControlStateNormal
      @restart_button.setBackgroundImage "navbar.png".uiimage, forState: UIControlStateHighlighted
      @restart_button.setTitle "Restart the app", forState: UIControlStateNormal
      @restart_button.frame = [[10, 130], [300, 50]]
      @restart_button.addTarget(self,
                               action: :restart_app_alert,
                               forControlEvents: UIControlEventTouchUpInside)
      self.addSubview @restart_button
    end
  end

  def restart_app_alert
    UIActionSheet.alert "Restart the app?", buttons: ['Cancel', 'Restart'],
      cancel: proc { },
      destructive: proc { self.target.restart_app }
  end

  def update_web_dynos_count(count)
    @web_dynos_count_label.text = count.to_s
  end

  def update_other_dynos_count(count)
    @other_dynos_count_label.text = count.to_s
  end
end
