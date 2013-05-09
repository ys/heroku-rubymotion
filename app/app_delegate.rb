class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    UINavigationBar.appearance.setBackgroundImage 'depressed.png'.uiimage, forBarMetrics:UIBarMetricsDefault
    UINavigationBar.appearance.setTitleTextAttributes({
      UITextAttributeTextShadowColor => :clear.uicolor
    })
    UITabBar.appearance.setSelectionIndicatorImage "selection-tab.png".uiimage
    UITabBarItem.appearance.setTitleTextAttributes({
      UITextAttributeTextColor => :white.uicolor
    }, forState: UIControlStateNormal)
    UITabBarItem.appearance.setTitleTextAttributes({
      UITextAttributeTextColor => 0x20404B.uicolor
    }, forState: UIControlStateSelected)
    BaseController.alloc.init
    true
  end

end
