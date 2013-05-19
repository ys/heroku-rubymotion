class ApplicationContainerController < UITabBarController
  include SugarCube::CoreGraphics

  attr_accessor :app

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

    externalButton = UIButton.alloc.initWithFrame [[0,0],[28,19]]
    externalButton.setImage UIImage.imageNamed("external.png"), forState: UIControlStateNormal
    externalButton.setShowsTouchWhenHighlighted false
    externalButton.addTarget self, action: "openOptions", forControlEvents: UIControlEventTouchDown
    externalItem = UIBarButtonItem.alloc.initWithCustomView externalButton
    self.navigationItem.rightBarButtonItem = externalItem
  end

  def openOptions
    UIActionSheet.alert "What do you want to do", buttons: ['Cancel', nil, 'Open in Safari'],
      cancel: proc { },
      success: proc { |pressed| self.openInSafari if pressed == 'Show in Safari' }
  end

  def openInSafari
    app.web_url.nsurl.open
  end
end

