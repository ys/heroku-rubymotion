class ApplicationController < UIViewController
  include BW::KVO

  def init
    super
    tab_bar_item = UITabBarItem.alloc.initWithTitle "app", image:"app.png".uiimage, tag: 1
    tab_bar_item.setFinishedSelectedImage "app.png".uiimage,  withFinishedUnselectedImage: "app_white.png".uiimage
    self.tabBarItem = tab_bar_item
    self
  end

  def app=(app)
    @app = app
    observe(@app, :dynos) do |old_value, new_value|
      @app_view.update_other_dynos_count @app.other_dynos
      @app_view.update_web_dynos_count   @app.web_dynos
    end
  end

  def viewDidLoad
    add_show_menu_button
    unless @app.nil?
      add_app_view
    end
    self.view.backgroundColor = :white.uicolor
  end

  def add_show_menu_button
    backButton = UIButton.alloc.initWithFrame [[0, 0], [26, 26]]
    backButton.setImage("burger.png".uiimage, forState: UIControlStateNormal)
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

  def restart_app
    @app.restart do |response|
      if response.ok?
        TempAlert.alert "Restarted", true
      else
        TempAlert.alert "oops", false
      end
    end
  end
end
