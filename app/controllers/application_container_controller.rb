class ApplicationContainerController < UITabBarController
  include SugarCube::CoreGraphics

  attr_accessor :app

  def viewDidLoad
    frame = Rect(self.view.bounds)
    v = UIView.alloc.initWithFrame frame
    v.setBackgroundColor 0x05a367.uicolor
    self.tabBar.addSubview v
    add_show_menu_button
  end

  def add_show_menu_button
    externalButton = UIButton.alloc.initWithFrame [[0,0],[28,19]]
    externalButton.setImage UIImage.imageNamed("external.png"), forState: UIControlStateNormal
    externalButton.setShowsTouchWhenHighlighted false
    externalButton.addTarget self, action: "openOptions", forControlEvents: UIControlEventTouchDown
    externalItem = UIBarButtonItem.alloc.initWithCustomView externalButton
    self.navigationItem.rightBarButtonItem = externalItem
    backButton = UIButton.alloc.initWithFrame [[0, 0], [26, 26]]
    backButton.setImage UIImage.imageNamed("back.png"), forState: UIControlStateNormal
    backButton.setShowsTouchWhenHighlighted false
    frame = backButton.frame
    frame.size.width += 10
    backButton.frame = frame
    backButton.addTarget self, action: "popCurrentViewController", forControlEvents: UIControlEventTouchDown
    barBackItem = UIBarButtonItem.alloc.initWithCustomView backButton
    self.navigationItem.hidesBackButton = true
    self.navigationItem.leftBarButtonItem = barBackItem

  end

  def openOptions
    UIActionSheet.alert app.name, buttons: ['Cancel', nil, 'View in Safari'],
      cancel: proc { },
      success: proc { |pressed| self.openInSafari if pressed == 'View in Safari' }
  end

  def popCurrentViewController
    self.navigationController.popViewControllerAnimated true
  end

  def openInSafari
    app.web_url.nsurl.open
  end
end

