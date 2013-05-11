class NavigationController < UITableViewController
  include BW::KVO

  attr_accessor :delegate

  def init
    super
    @apps = []
    @apps_controllers = {}
    Application.all do |apps|
      @apps = apps
      self.view.reloadData
    end
    self
  end

  def viewDidLoad
    super
    self.view.separatorColor = 0xE79E8F.uicolor
    self.view.backgroundColor = :white.uicolor
    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.tintColor = 0xE79E8F.uicolor
    @refreshControl.addTarget self, action: :reload_apps, forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl
  end

  def reload_apps
    Application.all do |apps|
      @apps = apps
      self.view.reloadData
      @refreshControl.endRefreshing
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    if indexPath.row == @apps.size
      @reuseIdentifier = "MENUITEM_LOGOUT"
    else
      @reuseIdentifier = "MENUITEM"
    end

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    if indexPath.row != @apps.size
      # put your data in the cell
      cell.text = @apps[indexPath.row].name
      cell.textLabel.color = 0x4C6673.uicolor
      cell.contentView.backgroundColor = :clear.uicolor
    else
      cell.text = "Logout"
      cell.imageView.setImage "settings.png".uiimage
      cell.textLabel.color = 0x20404b.uicolor
      cell.contentView.backgroundColor = 0xD3C7B9.uicolor
    end
    cell.textLabel.backgroundColor = :clear.uicolor
    #cell.imageView.setImage "app_icon.png".uiimage
    selectedBackgroundView = UIView.alloc.initWithFrame(cell.frame)
    selectedBackgroundView.backgroundColor = 0xE79E8F.uicolor
    cell.textLabel.highlightedTextColor = 0x20404b.uicolor
    cell.selectedBackgroundView = selectedBackgroundView
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @apps.size + 1
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    if indexPath.row != @apps.size
      switch_to_app(indexPath)
    else
      show_settings
    end
  end

  def switch_to_app(indexPath)
    self.viewDeckController.closeLeftViewBouncing -> (controller) do
      app = @apps[indexPath.row]
      unless @apps_controllers[app.name]
        @apps_controllers[app.name] = {}
        application_controller = ApplicationController.alloc.init
        application_controller.app = app
        @apps_controllers[app.name][:app] = application_controller
        ps_controller = ProcessesController.alloc.init
        ps_controller.app = app
        @apps_controllers[app.name][:ps] = ps_controller
        config_controller = ConfigController.alloc.init
        config_controller.app = app
        @apps_controllers[app.name][:config] = config_controller
        addons_controller = AddonsController.alloc.init
        addons_controller.app = app
        @apps_controllers[app.name][:addons] = addons_controller
      end
      @tab_controller ||= ApplicationContainerController.alloc.initWithNibName(nil, bundle: nil)
      @tab_controller.selectedIndex = 0
      @tab_controller.viewControllers = [@apps_controllers[app.name][:app],
                                         @apps_controllers[app.name][:ps],
                                         @apps_controllers[app.name][:addons],
                                         @apps_controllers[app.name][:config]]
      @tab_controller.title = app.name
      self.viewDeckController.centerController.setViewControllers [@tab_controller], animated: false
    end
  end

  def show_settings
    UIActionSheet.alert "", buttons: ['Cancel', 'Logout'],
      cancel: proc { },
      destructive: proc { logout }
  end

  def logout
    User.destroy
    self.parentViewController.parentViewController.switch_to_login
  end

end

