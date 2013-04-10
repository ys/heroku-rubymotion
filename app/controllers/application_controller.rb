class ApplicationController < UIViewController
  include BW::KVO

  def init
    super
    tab_bar_item = UITabBarItem.alloc.initWithTitle "app", image:UIImage.imageNamed("app.png"), tag: 1
    self.tabBarItem = tab_bar_item
    self
  end

  def app=(app)
    @app = app
    observe(@app, :processes) do |old_value, new_value|
      @app_view.update_other_dynos_count @app.other_processes
      @app_view.update_web_dynos_count   @app.web_processes
    end
  end

  def viewDidLoad
    add_show_menu_button
    unless @app.nil?
      add_app_view
    end
    self.view.backgroundColor = UIColor.colorWithPatternImage UIImage.imageNamed("back.png")
  end

  def add_show_menu_button
    backButton = UIButton.alloc.initWithFrame [[0, 0], [26, 26]]
    backButton.setImage UIImage.imageNamed("burger.png"), forState: UIControlStateNormal
    backButton.setShowsTouchWhenHighlighted true
    backButton.addTarget self.viewDeckController, action: "toggleLeftView", forControlEvents: UIControlEventTouchDown
    barBackItem = UIBarButtonItem.alloc.initWithCustomView backButton
    self.navigationItem.hidesBackButton = true
    self.navigationItem.leftBarButtonItem = barBackItem
  end

  def add_app_view
    @app_view = ApplicationView.new(@app, self.view)
    @app_view.target = self
    self.view.addSubview @app_view
  end
end
