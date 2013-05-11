class ConfigController < UITableViewController

  attr_accessor :app

  def init
    super
    tab_bar_item = UITabBarItem.alloc.initWithTitle "config", image:"config.png".uiimage, tag: 4
    tab_bar_item.setFinishedSelectedImage "config.png".uiimage,  withFinishedUnselectedImage: "config_white.png".uiimage
    self.tabBarItem = tab_bar_item
    @data = []
    self
  end

  def viewDidLoad
    super
    @app.load_config do |config|
      @data = config
      view.reloadData
    end
    view.separatorColor = 0xD3C7B9.uicolor
    view.backgroundColor = :white.uicolor
    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.tintColor = 0xE79E8F.uicolor
    @refreshControl.addTarget self, action: :reload_config, forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl
  end

  def reload_config
    @app.load_config(true) do |config|
      @data = config
      self.view.reloadData
      @refreshControl.endRefreshing
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "CONFIG"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:@reuseIdentifier)
    end
    config_var = @data[indexPath.row]
    cell.textLabel.text = config_var.key.to_s.downcase
    cell.textLabel.textColor = 0x20404B.uicolor
    cell.textLabel.backgroundColor = :clear.uicolor
    cell.contentView.backgroundColor = :clear.uicolor

    cell.detailTextLabel.text = config_var.value.to_s
    cell.detailTextLabel.textColor = 0x4C6673.uicolor
    cell.detailTextLabel.backgroundColor = :clear.uicolor

    bg_view = UIView.alloc.init
    bg_view.setBackgroundColor 0xD3C7B9.uicolor
    cell.setSelectedBackgroundView bg_view
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
  end
end

