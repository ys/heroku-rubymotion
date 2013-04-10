class ApplicationContainerController < UITabBarController

  def viewDidLoad
    add_show_menu_button
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
end
