class CollaboratorsController < UITableViewController

  attr_accessor :app

  def init
    super
    tab_bar_item = UITabBarItem.alloc.initWithTitle "Collaborators", image:"collaborators.png".uiimage, tag: 2
    tab_bar_item.setFinishedSelectedImage "collaborators.png".uiimage,  withFinishedUnselectedImage: "collaborators_white.png".uiimage
    self.tabBarItem = tab_bar_item
    @data = []
    self
  end


  def viewDidLoad
    super
    self.view.separatorColor = 0xD3C7B9.uicolor
    self.view.backgroundColor = :white.uicolor
    load_collaborators(false)
    set_reloader
  end

  def set_reloader
    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.tintColor = 0xE79E8F.uicolor
    @refreshControl.addTarget self, action: :load_collaborators, forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl
  end

  def load_collaborators(refresh = true)
    @app.load_collaborators(refresh) do |collaborators|
      @data = collaborators
      self.view.reloadData
      @refreshControl.endRefreshing if refresh
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "PROCESS"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      CollaboratorView.alloc.init
    end
    cell.collaborator = @data[indexPath.row]
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end
end
