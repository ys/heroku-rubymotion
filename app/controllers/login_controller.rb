class LoginController < UIViewController

  attr_accessor :delegate

  def viewDidLoad
    super

    self.title = "Login with Heroku"
    view = self.view
    # configure background color
    view.backgroundColor = UIColor.whiteColor

    @user_field     = UITextField.alloc.initWithFrame([[60, 120], [200, 40]])
    @user_field.placeholder = "Email"
    @user_field.setBorderStyle UITextBorderStyleRoundedRect
    view.addSubview(@user_field)

    @password_field = UITextField.alloc.initWithFrame([[60, 160], [200, 40]])
    @password_field.placeholder = "Password"
    @password_field.secureTextEntry = true
    @password_field.setBorderStyle UITextBorderStyleRoundedRect
    view.addSubview(@password_field)

    @login_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @login_button.setTitle("Login with Heroku", forState: UIControlStateNormal)
    @login_button.frame = CGRectMake(0, 0, 200, 40);
    @login_button.center = view.center

    # connect an action method for login_with_github button
    @login_button.addTarget(self,
                            action: "login_with_heroku:",
                            forControlEvents: UIControlEventTouchUpInside)

    view.addSubview(@login_button)
  end

  def login_with_heroku(sender)
    Heroku.new.login(@user_field.text, @password_field.text) do |user_json|
      user_props = {
        id: user_json['id'],
        api_key: user_json['api_key']
      }
      user = User.new(user_props)
      user.save
      @delegate.init_deck
      view.addSubview(@password_field)
    end
  end
end

