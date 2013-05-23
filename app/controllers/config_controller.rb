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
    view.separatorColor = 0xD3C7B9.uicolor
    view.backgroundColor = :white.uicolor

    load_config(false)
    set_reloader
  end

  def load_config(refresh = true)
    @app.load_config(refresh) do |config|
      @data = config
      self.view.reloadData
      @refreshControl.endRefreshing if refresh
    end
  end

  def set_reloader
    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.tintColor = 0xE79E8F.uicolor
    @refreshControl.addTarget self, action: :load_config, forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "CONFIG"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
    ConfigView.alloc.init
    end
    cell.config = @data[indexPath.row]

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    config = @data[indexPath.row]
    alert = BW::UIAlertView.plain_text_input(title: config.key, placeholder: config.value) do |alert|
      unless alert.clicked_button.cancel?
        new_value = alert.plain_text_field.text
        if config.value != new_value && new_value.size > 0
          config.value = new_value
          app.update_config(config) do |response|
            if response.ok?
              TempAlert.alert "Saved", true
            else
              TempAlert.alert "Oops", false
            end
            self.view.reloadData
          end
        end
      end
    end
    alert.show
  end
end

