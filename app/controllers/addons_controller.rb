class AddonsController < UITableViewController

  attr_accessor :app

  def init
    super
    tab_bar_item = UITabBarItem.alloc.initWithTitle "addons", image: "addons.png".uiimage, tag: 3
    tab_bar_item.setFinishedSelectedImage "addons.png".uiimage,  withFinishedUnselectedImage: "addons_white.png".uiimage
    self.tabBarItem = tab_bar_item
    @data = []
    self
  end

  def viewDidLoad
    super
    view.separatorColor = 0xD3C7B9.uicolor
    view.backgroundColor = :white.uicolor

    load_addons(false)
    set_reloader
  end

  def load_addons(refresh = true)
    @app.load_addons(refresh) do |addons|
      @data = addons
      view.reloadData
      @refreshControl.endRefreshing if refresh
    end
  end

  def set_reloader
    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.tintColor = 0xE79E8F.uicolor
    @refreshControl.addTarget self, action: :load_addons, forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "ADDON"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      AddonView.alloc.init
    end
    cell.addon = @data[indexPath.row]

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end
end
