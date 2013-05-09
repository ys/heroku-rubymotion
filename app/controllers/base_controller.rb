class BaseController < UIViewController

  def init
    super
    @window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    if User.current && User.current.api_key
      init_deck
    else
      init_login
    end
    @window.makeKeyAndVisible
  end

  def viewDidLoad
  end

  def init_deck
    deck_controller = DeckController.alloc.init
    @window.rootViewController = deck_controller
  end

  def init_login
    login_controller = LoginController.new
    login_controller.delegate = self
    @window.rootViewController = login_controller
  end

end

