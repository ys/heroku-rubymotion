class ApplicationController < UIViewController

  def initWithApp(app)
    @app = app
    self
  end

  def viewDidLoad
    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithImage UIImage.imageNamed("burger.png"),
      style: UIBarButtonItemStylePlain,
      target: self.viewDeckController,
      action: "toggleLeftView"
    if @app.nil?
      self.view.backgroundColor = UIColor.redColor
    else
      self.view.backgroundColor = UIColor.blueColor
    end

  end
end
