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
    self.view.separatorColor = 0xD3C7B9.uicolor
    self.view.backgroundColor = :white.uicolor
    @data = @app.process_types_with_count
    set_reloader
  end

  def set_reloader
    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.tintColor = 0xE79E8F.uicolor
    @refreshControl.addTarget self, action: :load_processes, forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl
  end

  def load_processes(refresh = true)
    @app.load_processes(refresh) do |apps|
      @data = @app.process_types_with_count
      self.view.reloadData
      @refreshControl.endRefreshing if refresh
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "PROCESS"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      ProcessView.alloc.init
    end
    cell.process = @data[indexPath.row]
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end
end
