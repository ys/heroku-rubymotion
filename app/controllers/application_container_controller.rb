class ApplicationContainerController < UITabBarController
  include SugarCube::CoreGraphics

  def viewDidLoad
    frame = Rect(self.view.bounds)
    v = UIView.alloc.initWithFrame frame
    v.setBackgroundColor 0xE17666.uicolor
    self.tabBar.addSubview v
    add_show_menu_button
  end

  def add_show_menu_button
    backButton = UIButton.alloc.initWithFrame [[0, 0], [26, 26]]
    backButton.setImage UIImage.imageNamed("burger.png"), forState: UIControlStateNormal
    backButton.setShowsTouchWhenHighlighted false
    backButton.addTarget self.viewDeckController, action: "toggleLeftView", forControlEvents: UIControlEventTouchDown
    barBackItem = UIBarButtonItem.alloc.initWithCustomView backButton
    self.navigationItem.hidesBackButton = true
    self.navigationItem.leftBarButtonItem = barBackItem
    settingsButton = UIButton.alloc.initWithFrame [[0, 0], [26, 26]]
    settingsButton.setImage UIImage.imageNamed("settings.png"), forState: UIControlStateNormal
    settingsButton.setShowsTouchWhenHighlighted false
    settingsButton.addTarget self, action: "show_settings", forControlEvents: UIControlEventTouchDown
    settingsItem = UIBarButtonItem.alloc.initWithCustomView settingsButton
    self.navigationItem.rightBarButtonItem = settingsItem
  end

  def show_settings
    UIActionSheet.alert "", buttons: ['Cancel', 'Logout'],
      cancel: proc { },
      destructive: proc { logout }
  end

  def logout
    User.destroy
    self.parentViewController.parentViewController.parentViewController.switch_to_login
  end
end
