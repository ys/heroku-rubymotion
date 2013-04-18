class NavigationController < UIViewController

  attr_accessor :delegate

  def init
    super
    @apps = []
    Application.all do |apps|
      @apps = apps
      @table.reloadData
    end
    self
  end

  def viewDidLoad
    super
    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.addSubview @table
    @table.dataSource = self
    @table.delegate = self
    @table.separatorColor = 0xcccccc.uicolor
    @table.backgroundColor = :white.uicolor
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "MENU"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end

    # put your data in the cell
    cell.text = @apps[indexPath.row].name
    cell.textLabel.backgroundColor = :clear.uicolor
    cell.textLabel.color = :gray.uicolor
    cell.imageView.setImage "app_icon.png".uiimage
    cell.contentView.backgroundColor = :clear.uicolor
    selectedBackgroundView = UIView.alloc.initWithFrame(cell.frame)
    selectedBackgroundView.backgroundColor = 0xcccccc.uicolor
    cell.selectedBackgroundView = selectedBackgroundView
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @apps.size
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    switch_to_app(indexPath)
  end

  def tableView(tableView, titleForHeaderInSection:section)
    "Applications"
  end

  def switch_to_app(indexPath)
    self.viewDeckController.closeLeftViewBouncing -> (controller) do
      app = @apps[indexPath.row]
      app
      @application_controller = ApplicationController.alloc.init
      @application_controller.app = app
      self.viewDeckController.panningView = @application_controller.view
      @ps_controller = ProcessesController.alloc.init
      @ps_controller.app = app
      @config_controller = ConfigController.alloc.init
      @config_controller.app = app
      @addons_controller = AddonsController.alloc.init
      @addons_controller.app = app
      @tab_controller ||= ApplicationContainerController.alloc.initWithNibName(nil, bundle: nil)
      @tab_controller.viewControllers = [@application_controller, @ps_controller, @addons_controller, @config_controller ]
      @tab_controller.title = app.name
      self.viewDeckController.centerController.setViewControllers [@tab_controller], animated: false
    end
  end

end

