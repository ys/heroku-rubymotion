class AppDelegate

  attr_reader :base_controller, :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    NewRelicAgent.startWithApplicationToken NSBundle.mainBundle.objectForInfoDictionaryKey('NEWRELIC_APP')

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
    @window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = MainController.alloc.init
    @window.makeKeyAndVisible
    true
  end

end
