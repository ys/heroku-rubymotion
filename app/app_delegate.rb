class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    if User.current && User.current.api_key
      init_deck
    else
      login_controller = LoginController.new
      login_controller.delegate = self
      @window.rootViewController = login_controller
    end
    image_view = UIImageView.alloc.initWithImage("Default.png".uiimage)
    @window.rootViewController.view.addSubview(image_view)
    @window.rootViewController.view.bringSubviewToFront(image_view)
    @window.makeKeyAndVisible
    fade_out_timer = 1.0
    UIView.transitionWithView(@window, duration:fade_out_timer, options:UIViewAnimationOptionTransitionNone, animations: lambda {image_view.alpha = 0}, completion: lambda do |finished|
      image_view.removeFromSuperview
      image_view = nil
      UIApplication.sharedApplication.setStatusBarHidden(false, animated:false)
    end)
    true
  end

  def init_deck
    deck_controller = DeckController.alloc.init
    @window.rootViewController = deck_controller
  end
end
