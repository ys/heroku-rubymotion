class MenuController < UIViewController
  def viewDidLoad
    super
    @menu_view = MenuView.new(view)
    @menu_view.target = self
    view.addSubview @menu_view
  end

  def show_applications(sender)
    self.viewDeckController.closeLeftViewBouncing proc { |arg| }
  end

  def show_logout(sender)
    UIActionSheet.alert "", buttons: ['Cancel', 'Logout'],
      cancel: proc { },
      destructive: proc { logout }
  end

  def logout
    User.destroy
    self.parentViewController.parentViewController.switch_to_login
  end
end
