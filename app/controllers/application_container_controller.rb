class ApplicationContainerController < UIViewController

  def app=(app)
    @app = app
  end

  def viewDidLoad
    add_show_menu_button
    unless @app.nil?
      self.title = @app.name
      add_app_view
      @app.load_processes do |processes|
        @app_view.update_web_dynos_count   @app.web_processes
        @app_view.update_other_dynos_count @app.other_processes
      end
    end
    self.view.backgroundColor = UIColor.colorWithPatternImage UIImage.imageNamed("back.png")
  end

  def add_show_menu_button
    backButton = UIButton.alloc.initWithFrame [[0, 0], [26, 26]]
    backButton.setImage UIImage.imageNamed("burger.png"), forState: UIControlStateNormal
    backButton.setShowsTouchWhenHighlighted true
    backButton.addTarget self.viewDeckController, action: "toggleLeftView", forControlEvents: UIControlEventTouchDown
    barBackItem = UIBarButtonItem.alloc.initWithCustomView backButton
    self.navigationItem.hidesBackButton = true
    self.navigationItem.leftBarButtonItem = barBackItem
  end

  def add_app_view
    @app_view = ApplicationView.new(@app, self.view)
    @app_view.target = self
    self.view.addSubview @app_view
  end

  def switch_to_processes
    @ps_controller = ProcessesController.alloc.init
    @ps_controller.app = @app
    self.navigationController.pushViewController @ps_controller, animated: true
  end
end
