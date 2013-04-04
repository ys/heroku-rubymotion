class ApplicationView < UIView

  attr_accessor :target

  def initialize(app, parent_view)
    initWithFrame(parent_view.bounds).tap do
      web_dynos_label= UILabel.alloc.initWithFrame(CGRectMake(0, 30, 160, 16))
      web_dynos_label.text = "Web"
      web_dynos_label.textColor = UIColor.whiteColor
      web_dynos_label.backgroundColor = UIColor.clearColor
      web_dynos_label.textAlignment = UITextAlignmentCenter
      self.addSubview web_dynos_label

      other_dynos_label= UILabel.alloc.initWithFrame(CGRectMake(160, 30, 160, 16))
      other_dynos_label.text = "Other"
      other_dynos_label.textColor = UIColor.whiteColor
      other_dynos_label.backgroundColor = UIColor.clearColor
      other_dynos_label.textAlignment = UITextAlignmentCenter
      self.addSubview other_dynos_label

      @web_dynos_count_label= UILabel.alloc.initWithFrame(CGRectMake(0, 50, 160, 40))
      @web_dynos_count_label.text = app.web_processes.to_s
      @web_dynos_count_label.textColor = UIColor.whiteColor
      @web_dynos_count_label.backgroundColor = UIColor.clearColor
      @web_dynos_count_label.textAlignment = UITextAlignmentCenter
      @web_dynos_count_label.font = UIFont.systemFontOfSize 40
      self.addSubview @web_dynos_count_label

      @other_dynos_count_label= UILabel.alloc.initWithFrame(CGRectMake(160, 50, 160, 40))
      @other_dynos_count_label.text = app.other_processes.to_s
      @other_dynos_count_label.textColor = UIColor.whiteColor
      @other_dynos_count_label.backgroundColor = UIColor.clearColor
      @other_dynos_count_label.textAlignment = UITextAlignmentCenter
      @other_dynos_count_label.font = UIFont.systemFontOfSize 40
      self.addSubview @other_dynos_count_label

      ps_button = UIButton.buttonWithType UIButtonTypeRoundedRect
      ps_button.setTitle "Show processes", forState: UIControlStateNormal
      ps_button.frame = [[10, 180], [300, 50]]
      ps_button.addTarget(self.target,
        action: :switch_to_processes,
        forControlEvents: UIControlEventTouchUpInside)
      self.addSubview ps_button
    end
  end

  def update_web_dynos_count(count)
    @web_dynos_count_label.text = count.to_s
  end

  def update_other_dynos_count(count)
    @other_dynos_count_label.text = count.to_s
  end
end
