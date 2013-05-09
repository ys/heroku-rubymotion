class ProcessesController < UITableViewController

  attr_accessor :app

  def init
    super
    tab_bar_item = UITabBarItem.alloc.initWithTitle "PS", image:"ps.png".uiimage, tag: 2
    tab_bar_item.setFinishedSelectedImage "ps.png".uiimage,  withFinishedUnselectedImage: "ps_white.png".uiimage
    self.tabBarItem = tab_bar_item
    self
  end


  def viewDidLoad
    super
    @data = @app.process_types_with_count
    self.view.separatorColor = 0xD3C7B9.uicolor
    self.view.backgroundColor = :white.uicolor
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "PROCESS"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      ProcessView.new @data[indexPath.row]
    end

    bg_view = UIView.alloc.init
    bg_view.setBackgroundColor 0xD3C7B9.uicolor
    cell.setSelectedBackgroundView bg_view
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end

  #EDIT THE ROW => Restart
  def tableView(tableView, canEditRowAtIndexPath:indexPath)
    false
  end
end
