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
    left_controller = NavigationController.alloc.init
    application_controller = ApplicationController.alloc.initWithApp nil
    deck_controller = IIViewDeckController.alloc.initWithCenterViewController(application_controller, leftViewController: left_controller)
    @window.rootViewController = deck_controller
  end
end
