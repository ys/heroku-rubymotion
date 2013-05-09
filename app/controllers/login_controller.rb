class LoginController < UIViewController

  attr_accessor :delegate

  def viewDidLoad
    super
    self.title = "Login with Heroku"
    @login_view = LoginView.new(view)
    @login_view.target = self
    view.backgroundColor = 0xD3C7B9.uicolor
    view.addSubview @login_view
  end

  def login_with_heroku(sender)
    @after_post = lambda do |response|
      if response.ok?
        user_props = {
          id:      response.json['id'],
          api_key: response.json['api_key']
        }
        user = User.new(user_props)
        user.save
        @delegate.init_deck
      else
        TempAlert.alert "Login failed", false
      end
    end
    Heroku.new.login(@login_view.login_value, @login_view.password_value, &@after_post)
  end
end

