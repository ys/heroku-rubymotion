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
    @table.separatorColor = UIColor.clearColor
    @table.backgroundColor = UIColor.whiteColor
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "MENU"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end

    # put your data in the cell
    cell.text = @apps[indexPath.row].name
    cell.textLabel.backgroundColor = UIColor.clearColor
    cell.textLabel.color = UIColor.grayColor
    cell.imageView.setImage UIImage.imageNamed("app_icon.png")
    cell.contentView.backgroundColor = UIColor.clearColor
    selectedBackgroundView = UIView.alloc.initWithFrame(cell.frame)
    selectedBackgroundView.backgroundColor = UIColor.colorWithRed( 0.53, green: 0.53, blue: 0.53, alpha: 0.6)
    cell.selectedBackgroundView = selectedBackgroundView
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @apps.size
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    switch_to_app(indexPath)
  end

  def switch_to_app(indexPath)
    self.viewDeckController.closeLeftViewBouncing -> (controller) do
      @application_controller = ApplicationContainerController.alloc.init
      @application_controller.app = @apps[indexPath.row]
      self.viewDeckController.centerController.setViewControllers [@application_controller], animated: false
    end
  end
end

