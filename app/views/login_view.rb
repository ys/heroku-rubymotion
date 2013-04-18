class LoginView < UIView

  attr_accessor :target

  def initialize(parent_view)
    initWithFrame(parent_view.bounds).tap do

      @user_field     = UITextField.alloc.initWithFrame([[60, 120], [200, 40]])
      @user_field.placeholder = "Email"
      @user_field.setBorderStyle UITextBorderStyleRoundedRect
      addSubview(@user_field)

      @password_field = UITextField.alloc.initWithFrame([[60, 170], [200, 40]])
      @password_field.placeholder = "Password"
      @password_field.secureTextEntry = true
      @password_field.setBorderStyle UITextBorderStyleRoundedRect
      addSubview(@password_field)

      @login_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      @login_button.setTitle("Login with Heroku", forState: UIControlStateNormal)
      @login_button.frame = CGRectMake(60, 220, 200, 40);

      # connect an action method for login_with_github button
      @login_button.addTarget(target,
                              action: "login_with_heroku:",
                              forControlEvents: UIControlEventTouchUpInside)

      addSubview(@login_button)
    end
  end

  def login_value
    @user_field.text
  end

  def password_value
    @password_field.text
  end
end
