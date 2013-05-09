class MainController < UIViewController

  def init
    super
    @deck_controller = DeckController.alloc.init
    @deck_controller.view.frame = UIScreen.mainScreen.bounds
    @login_controller = LoginController.alloc.init
    @login_controller.view.frame = UIScreen.mainScreen.bounds
    @login_controller.delegate = self
    self
  end

  def viewDidLoad
    super
    self.addChildViewController @deck_controller
    self.addChildViewController @login_controller
    if User.current && User.current.api_key
      init_deck
    else
      init_login
    end
  end

  def init_deck
    self.view.addSubview @deck_controller.view
  end

  def init_login
    self.view.addSubview @login_controller.view
  end

  def switch_to_deck
    self.transitionFromViewController @login_controller, toViewController: @deck_controller,
                                                         duration: 0.3,
                                                         options: UIViewAnimationOptionTransitionCrossDissolve,
                                                         animations:nil,
                                                         completion: ->(arg) {}
  end

  def switch_to_login
    self.transitionFromViewController @deck_controller, toViewController: @login_controller,
                                                         duration: 0.3,
                                                         options: UIViewAnimationOptionTransitionCrossDissolve,
                                                         animations:nil,
                                                         completion: ->(arg) {}
  end


end


