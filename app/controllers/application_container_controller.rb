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
    frame = backButton.frame
    frame.size.width += 10
    backButton.frame = frame
    backButton.addTarget self.viewDeckController, action: "toggleLeftView", forControlEvents: UIControlEventTouchDown
    barBackItem = UIBarButtonItem.alloc.initWithCustomView backButton
    self.navigationItem.hidesBackButton = true
    self.navigationItem.leftBarButtonItem = barBackItem
  end
end
