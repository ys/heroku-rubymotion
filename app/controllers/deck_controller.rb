class DeckController < IIViewDeckController

  def init
    super
    self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose
    applications_controller = ApplicationsController.alloc.init
    menu_controller = MenuController.alloc.init
    nav_controller ||= UINavigationController.alloc.initWithRootViewController(applications_controller)
    nav_controller.navigationBar.tintColor = 0xE17666.uicolor
    self.leftSize = 150
    self.leftController = menu_controller
    self.centerController = nav_controller
    self.navigationControllerBehavior = IIViewDeckNavigationControllerIntegrated
    self
  end
end
