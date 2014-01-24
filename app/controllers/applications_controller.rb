class ApplicationsController < UITableViewController

  stylesheet :list_screen

  attr_accessor :delegate

  def init
    super
    self.title = 'Applications'
    @apps = if App::Persistence["apps"]
              App::Persistence["apps"].map{|name| Application.new(name: name) }
            else
              []
            end
    @apps_controllers = {}
    Application.all do |apps|
      @apps = apps.sort_by(&:name)
      self.view.reloadData
    end
    self
  end

  def viewDidLoad
    super
    self.view.separatorColor = 0xffe8da.uicolor
    self.view.backgroundColor = :white.uicolor
    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.tintColor = 0xE79E8F.uicolor
    @refreshControl.addTarget self, action: :reload, forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl
    add_button
  end

  def add_button
    backButton = UIButton.alloc.initWithFrame [[0, 0], [26, 26]]
    backButton.setImage UIImage.imageNamed("burger.png"), forState: UIControlStateNormal
    backButton.setShowsTouchWhenHighlighted false
    frame = backButton.frame
    frame.size.width += 10
    backButton.frame = frame
    backButton.addTarget self.viewDeckController, action: "toggleLeftView", forControlEvents: UIControlEventTouchDown
    barBackItem = UIBarButtonItem.alloc.initWithCustomView backButton
    self.navigationItem.hidesBackButton = true
    self.navigationItem.leftBarButtonItem = barBackItem
  end



  def reload
    Application.all do |apps|
      @apps = apps
      self.view.reloadData
      @refreshControl.endRefreshing
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier = "MENUITEM"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    # put your data in the cell
    cell.text = @apps[indexPath.row].name.to_s
    cell.textLabel.color = 0x222222.uicolor
    cell.contentView.backgroundColor = :clear.uicolor
    cell.textLabel.backgroundColor = :clear.uicolor
    selectedBackgroundView = UIView.alloc.initWithFrame(cell.frame)
    selectedBackgroundView.backgroundColor = 0x3DCC95.uicolor
    cell.textLabel.highlightedTextColor = 0xffffff.uicolor
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
      app = @apps[indexPath.row]
      app_name = app.name.to_s
      controller_names = %w[application dynos addons config collaborators]
      unless @apps_controllers[app_name]
        @apps_controllers[app_name] = {}
        controller_names.each{|controller_name|
          controller = Kernel.const_get("#{controller_name.capitalize}Controller").alloc.init
          controller.app = app
          @apps_controllers[app_name][controller_name.to_sym] = controller
        }
      end
      @tab_controller ||= ApplicationContainerController.alloc.initWithNibName(nil, bundle: nil)
      @tab_controller.selectedIndex = 0
      @tab_controller.app = app
      @tab_controller.viewControllers = controller_names.map { |name| @apps_controllers[app_name][name.to_sym] }
      @tab_controller.title = app_name
      self.navigationController.pushViewController @tab_controller, animated: true
  end


end

