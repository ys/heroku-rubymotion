class MainController < UIViewController

  def init
    super
    self
  end

  def viewDidLoad
    super
    if User.current && User.current.api_key
      init_deck
    else
      init_login
    end
  end

  def init_deck
    @deck_controller = DeckController.alloc.init
    @deck_controller.view.frame = UIScreen.mainScreen.bounds
    self.addChildViewController @deck_controller
    self.view.addSubview @deck_controller.view
  end

  def init_login
    @login_controller = LoginController.alloc.init
    @login_controller.view.frame = UIScreen.mainScreen.bounds
    @login_controller.delegate = self
    self.addChildViewController @login_controller
    self.view.addSubview @login_controller.view
  end

  def switch_to_deck
    init_deck unless @deck_controller
    transition @login_controller, @deck_controller,
  end

  def switch_to_login
    init_login unless @login_controller
    transition @deck_controller, @login_controller
  end

  def transition(from, to)
    self.transitionFromViewController from, toViewController: to,
                                            duration: 0.3,
                                            options: UIViewAnimationOptionTransitionCrossDissolve,
                                            animations:nil,
                                            completion: ->(arg) {}
  end

end


