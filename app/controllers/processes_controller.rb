class ProcessesController < UITableViewController

  attr_accessor :app

  def init
    super
    tab_bar_item = UITabBarItem.alloc.initWithTitle "PS", image:"ps.png".uiimage, tag: 2
    self.tabBarItem = tab_bar_item
    self
  end


  def viewDidLoad
    super
    @data = @app.process_types_with_count
    self.view.separatorColor = 0xcccccc.uicolor
    self.view.backgroundColor = "back.png".uicolor
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "PROCESS"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      ProcessView.new @data[indexPath.row]
    end

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
