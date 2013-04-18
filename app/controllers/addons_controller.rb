class AddonsController < UITableViewController

  attr_accessor :app

  def init
    super
    tab_bar_item = UITabBarItem.alloc.initWithTitle "addons", image: "addons.png".uiimage, tag: 3
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
    view.separatorColor = 0xcccccc.uicolor
    view.backgroundColor = "back.png".uicolor
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "PROCESS"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    addon = @data[indexPath.row]
    :x
    :w

    cell.textLabel.text = addon.full_description
    cell.textLabel.textColor = 0x555555.uicolor
    cell.textLabel.backgroundColor = :clear.uicolor
    cell.contentView.backgroundColor = :clear.uicolor

    cell.selectionStyle = UITableViewCellSelectionStyleGray

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    puts @data[indexPath.row].url
  end
end
