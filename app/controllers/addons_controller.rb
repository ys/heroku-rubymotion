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
    @app.load_addons do |addons|
      @data = addons
      view.reloadData
    end
    view.separatorColor = 0xD3C7B9.uicolor
    view.backgroundColor = :white.uicolor
    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.tintColor = 0xE79E8F.uicolor
    @refreshControl.addTarget self, action: :reload_addons, forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl
  end

  def reload_addons
    @app.load_addons(true) do |addons|
      @data = addons
      self.view.reloadData
      @refreshControl.endRefreshing
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "PROCESS"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    addon = @data[indexPath.row]

    cell.textLabel.text = addon.full_description.to_s
    cell.textLabel.textColor = 0x20404B.uicolor
    cell.textLabel.backgroundColor = :clear.uicolor
    cell.contentView.backgroundColor = :clear.uicolor

    bg_view = UIView.alloc.init
    bg_view.setBackgroundColor 0xD3C7B9.uicolor
    cell.setSelectedBackgroundView bg_view

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    puts @data[indexPath.row].url
  end
end
