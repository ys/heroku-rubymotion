class AddonsController < UITableViewController

  attr_accessor :app

  def init
    super
    tab_bar_item = UITabBarItem.alloc.initWithTitle "addons", image: UIImage.imageNamed("addons.png"), tag: 3
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
    view.separatorColor = UIColor.clearColor
    view.backgroundColor = UIColor.colorWithPatternImage UIImage.imageNamed("back.png")
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "PROCESS"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    addon = @data[indexPath.row]

    cell.textLabel.text = addon.full_description
    cell.textLabel.textColor = UIColor.whiteColor
    cell.textLabel.backgroundColor = UIColor.clearColor
    cell.contentView.backgroundColor = UIColor.clearColor

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    puts @data[indexPath.row].url
  end
end
