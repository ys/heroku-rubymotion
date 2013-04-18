class ChooseApplicationView < UIView

  attr_accessor :target

  def initialize(parent_view)
    initWithFrame(parent_view.bounds).tap do
      self.backgroundColor = "back.png".uicolor
      @welcome_label= UILabel.alloc.initWithFrame(CGRectMake(0, 60, 320, 50))
      @welcome_label.text = "WELCOME SAMURAI"
      @welcome_label.textColor = 0x555555.uicolor
      @welcome_label.backgroundColor = :clear.uicolor
      @welcome_label.textAlignment = UITextAlignmentCenter
      @welcome_label.font = UIFont.systemFontOfSize 30
      self.addSubview @welcome_label
      @choose_app_label= UILabel.alloc.initWithFrame(CGRectMake(0, 100, 320, 30))
      @choose_app_label.text = "Please choose an app"
      @choose_app_label.textColor = 0x555555.uicolor
      @choose_app_label.backgroundColor = :clear.uicolor
      @choose_app_label.textAlignment = UITextAlignmentCenter
      @choose_app_label.font = UIFont.systemFontOfSize 25
      self.addSubview @choose_app_label
    end
  end
end
