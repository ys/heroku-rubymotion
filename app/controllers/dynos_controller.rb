class DynosController < UITableViewController

  attr_accessor :app

  def init
    super
    tab_bar_item = UITabBarItem.alloc.initWithTitle "Dynos", image:"ps.png".uiimage, tag: 2
    tab_bar_item.setFinishedSelectedImage "ps.png".uiimage,  withFinishedUnselectedImage: "ps_white.png".uiimage
    self.tabBarItem = tab_bar_item
    @data = []
    self
  end


  def viewDidLoad
    super
    self.view.separatorColor = 0xD3C7B9.uicolor
    self.view.backgroundColor = :white.uicolor
    load_dynos(false)
    set_reloader
  end

  def set_reloader
    @refreshControl = UIRefreshControl.alloc.init
    @refreshControl.tintColor = 0xE79E8F.uicolor
    @refreshControl.addTarget self, action: :load_dynos, forControlEvents:UIControlEventValueChanged
    self.refreshControl = @refreshControl
  end

  def load_dynos(refresh = true)
    @app.load_formation(refresh) do |formation|
      @data = formation.sort_by(&:quantity).reverse
      self.view.reloadData
      @refreshControl.endRefreshing if refresh
    end
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    # return the UITableViewCell for the row
    @reuseIdentifier ||= "DYNO"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
      DynoView.alloc.init
    end
    cell.dyno = @data[indexPath.row]
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    @dyno = @data[indexPath.row]
    @dyno_action = DynoAction.new(@dyno)
    @dyno_action.controller = self
  end
end

class DynoAction
  attr_accessor :controller

  def initialize(dyno)
    @dyno = dyno
    UIActionSheet.alert "Restart #{@dyno.type} dyno?", buttons: ['Cancel', 'Restart dyno', 'Number of Dynos'],
      cancel:      proc { },
      destructive: proc { restart_app },
      success:     proc { change_number_of_instances }
  end

  def restart_app
    @dyno.restart do |response|
      if response.ok?
        TempAlert.alert "Restarted", true
      else
        TempAlert.alert "oops", false
      end
    end
  end

  def change_number_of_instances
    @modal_view = UIControl.alloc.initWithFrame(self.controller.view.bounds)
    @modal_view.backgroundColor = :black.uicolor(0.5)
    @modal_view.alpha = 0.0

    @modal_view.on :touch do
      cancel
    end

    self.controller.view << @modal_view
    height = self.controller.tabBarController.view.bounds.size.height
    @keyboard_view = UIView.alloc.initWithFrame([[0, height], [320, 260]])  # y: 460, so offscreen, at the bottom.
    nav_bar = UINavigationBar.alloc.initWithFrame([[0, 0], [320, 44]])

    item = UINavigationItem.new
    item.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemCancel,
      target: self,
      action: :cancel)

    item.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(
      UIBarButtonSystemItemDone,
      target: self,
      action: :done)

    nav_bar.items = [item]  # if you want, play with assigning more items.  I dunno what happens!
    @keyboard_view << nav_bar
    @picker_delegate = self
    @picker_view = UIPickerView.alloc.initWithFrame([[0, 44], [320, 216]])
    @picker_view.showsSelectionIndicator = true
    @picker_view.delegate = @picker_view.dataSource = @picker_delegate
    @picker_view.selectRow(@dyno.quantity, inComponent:0, animated:false)
    @keyboard_view << @picker_view
    self.controller.tabBarController.view << @keyboard_view
    @modal_view.fade_in
    @keyboard_view.slide :up
  end

  def done
    @dyno.quantity = @picker_view.selectedRowInComponent(0)
    @dyno.update do |response|
      TempAlert.alert "#{@dyno.quantity} dynos", true
      self.controller.view.reloadData
    end
    cancel
  end

  def cancel
    @modal_view.fade_out
    @keyboard_view.slide :down
  end

  def numberOfComponentsInPickerView(picker_view)
    1
  end

  def pickerView(picker_view, numberOfRowsInComponent:section)
    100
  end

  def pickerView(picker_view, titleForRow:row, forComponent:section)
    count = (0..99).to_a[row]
    if count == 1
      "1 dyno"
    else
      "#{count} dynos"
    end
  end
end
