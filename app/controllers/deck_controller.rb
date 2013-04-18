class DeckController < IIViewDeckController

  def init
    super
    self.panningMode = IIViewDeckPanningViewPanning
    application_controller = ChooseAppController.alloc.init
    self.panningView = application_controller.view
    nav_controller ||= UINavigationController.alloc.initWithRootViewController(application_controller)
    nav_controller.navigationBar.tintColor = 0x555555.uicolor
    left_controller = NavigationController.alloc.init
    self.leftController = left_controller
    self.centerController = nav_controller
    self.navigationControllerBehavior = IIViewDeckNavigationControllerIntegrated
    self
  end
end
