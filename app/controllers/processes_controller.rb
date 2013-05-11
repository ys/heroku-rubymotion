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
    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.tintColor = 0xE79E8F.uicolor
    @refreshControl.addTarget self, action: :reload_processes, forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl
  end

  def reload_processes
    @app.load_processes(true) do |apps|
      @data = @app.process_types_with_count
      self.view.reloadData
      @refreshControl.endRefreshing
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "PROCESS"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      ProcessView.new @data[indexPath.row]
    end
    cell.process = @data[indexPath.row]

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
