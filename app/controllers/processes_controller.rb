class ProcessesController < UITableViewController

  attr_accessor :app

  def viewDidLoad
    super
    @data = @app.process_types_with_count
    self.view.separatorColor = UIColor.clearColor
    self.view.backgroundColor = UIColor.colorWithPatternImage UIImage.imageNamed("back.png")
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "PROCESS"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end
    ps = @data[indexPath.row]

    cell.textLabel.text = ps.type
    cell.textLabel.textColor = UIColor.whiteColor
    cell.textLabel.backgroundColor = UIColor.clearColor
    cell.contentView.backgroundColor = UIColor.clearColor

    count_label = UILabel.alloc.initWithFrame(CGRectMake(0, 0, 16, 16))
    count_label.text = ps.count.to_s
    count_label.textColor = UIColor.whiteColor
    count_label.backgroundColor = UIColor.clearColor

    cell.accessoryView = count_label
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end

end
