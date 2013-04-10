class ConfigController < UITableViewController

  attr_accessor :app

  def init
    super
    tab_bar_item = UITabBarItem.alloc.initWithTitle "config", image:UIImage.imageNamed("config.png"), tag: 4
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
    view.separatorColor = UIColor.clearColor
    view.backgroundColor = UIColor.colorWithPatternImage UIImage.imageNamed("back.png")
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "CONFIG"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    config_var = @data[indexPath.row]

    cell.textLabel.text = config_var.key
    cell.textLabel.textColor = UIColor.whiteColor
    cell.textLabel.backgroundColor = UIColor.clearColor
    cell.contentView.backgroundColor = UIColor.clearColor

    value_label = UILabel.alloc.initWithFrame(CGRectMake(0, 0, 16, 16))
    value_label.text = config_var.value
    value_label.textColor = UIColor.whiteColor
    value_label.backgroundColor = UIColor.clearColor

    cell.accessoryView = value_label

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    puts @data[indexPath.row].url
  end
end

