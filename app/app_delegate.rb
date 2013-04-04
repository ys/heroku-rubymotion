class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    if User.current && User.current.api_key
      init_deck
    else
      login_controller = LoginController.new
      login_controller.delegate = self

      @window.rootViewController = login_controller
    end
  end

  def init_deck
    application_controller = ApplicationContainerController.alloc.init
    nav_controller ||= UINavigationController.alloc.initWithRootViewController(application_controller)
    left_controller = NavigationController.alloc.init
    deck_controller = IIViewDeckController.alloc.initWithCenterViewController(nav_controller, leftViewController: left_controller)
    @window.rootViewController = deck_controller
  end
end
