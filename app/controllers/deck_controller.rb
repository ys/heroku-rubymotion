class DeckController < IIViewDeckController

  def init
    super
    #self.panningMode = IIViewDeckPanningViewPanning
    application_controller = ChooseAppController.alloc.init
    #self.panningView = application_controller.view
    self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose
    nav_controller ||= UINavigationController.alloc.initWithRootViewController(application_controller)
    nav_controller.navigationBar.tintColor = 0xE17666.uicolor
    left_controller = NavigationController.alloc.init
    self.leftController = left_controller
    self.centerController = nav_controller
    self.navigationControllerBehavior = IIViewDeckNavigationControllerIntegrated
    self
  end
end
