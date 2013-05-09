class LoginView < UIView

  attr_accessor :target

  def initialize(parent_view)
    initWithFrame(parent_view.bounds).tap do
      self.backgroundColor = 0xD3C7B9.uicolor

      image_view = UIImageView.alloc.initWithFrame([[10, 40],[300, 67]])
      image_view.image = "logo.png".uiimage
      image_view.contentMode = UIViewContentModeScaleToFill
      addSubview image_view

      @user_field = UITextField.alloc.initWithFrame([[10, 140], [300, 50]])
      @user_field.placeholder = "Email"
      @user_field.backgroundColor = :white.uicolor
      @user_field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
      paddingView = UIView.alloc.initWithFrame [[0, 0], [10, 50]]
      @user_field.leftView = paddingView;
      @user_field.leftViewMode = UITextFieldViewModeAlways;
      @user_field.delegate = self
      addSubview(@user_field)

      @password_field = UITextField.alloc.initWithFrame([[10, 200], [300, 50]])
      @password_field.backgroundColor = :white.uicolor
      @password_field.placeholder = "Password"
      @password_field.secureTextEntry = true
      @password_field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
      paddingView = UIView.alloc.initWithFrame [[0, 0], [10, 50]]
      @password_field.leftView = paddingView;
      @password_field.leftViewMode = UITextFieldViewModeAlways;
      @password_field.delegate = self
      addSubview(@password_field)

      login_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      login_button
      login_button.setTitle("Login with Heroku", forState: UIControlStateNormal)
      login_button.setTitleColor 0x20404B.uicolor, forState: UIControlStateNormal
      login_button.setTitleColor :white.uicolor, forState: UIControlStateHighlighted
      login_button.setBackgroundImage "light_pink.png".uiimage, forState: UIControlStateNormal
      login_button.setBackgroundImage "navbar.png".uiimage, forState: UIControlStateHighlighted
      login_button.frame = [[10, 260], [300, 50]]

      login_button.addTarget(target,
                              action: "login_with_heroku:",
                              forControlEvents: UIControlEventTouchUpInside)

      addSubview(login_button)
    end
  end

  def login_value
    @user_field.text
  end

  def password_value
    @password_field.text
  end

  def reset_fields
    @user_field.text = ""
    @password_field.text = ""
  end

  def textFieldShouldReturn(text_field)
    text_field.resignFirstResponder
  end

end
