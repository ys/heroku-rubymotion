class MenuView < UIView

  attr_accessor :target

  def initialize(parent_view)
    initWithFrame(parent_view.bounds).tap do
      self.backgroundColor = :lightgray.uicolor

      applications_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      applications_button.setTitle("Applications", forState: UIControlStateNormal)
      applications_button.setTitleColor :white.uicolor, forState: UIControlStateNormal
      applications_button.setTitleColor :lightgray.uicolor, forState: UIControlStateHighlighted
      applications_button.setContentHorizontalAlignment UIControlContentHorizontalAlignmentLeft
      applications_button.setBackgroundImage "applications.png".uiimage, forState: UIControlStateNormal
      applications_button.setBackgroundImage "applications.png".uiimage, forState: UIControlStateHighlighted
      applications_button.frame = [[0, 0], [300, 50]]
      applications_button.setTitleEdgeInsets UIEdgeInsetsMake(0.0, 20, 0.0, 0.0)

      applications_button.addTarget(target,
                             action: "show_applications:",
                             forControlEvents: UIControlEventTouchUpInside)

      addSubview(applications_button)

      logout_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      logout_button.setTitle("logout", forState: UIControlStateNormal)
      logout_button.setTitleColor :white.uicolor, forState: UIControlStateNormal
      logout_button.setTitleColor :lightgray.uicolor, forState: UIControlStateHighlighted
      logout_button.setContentHorizontalAlignment UIControlContentHorizontalAlignmentLeft
      logout_button.setBackgroundImage "logout.png".uiimage, forState: UIControlStateNormal
      logout_button.setBackgroundImage "logout.png".uiimage, forState: UIControlStateHighlighted
      logout_button.frame = [[0, (App.frame.size.height - 50)], [300, 50]]
      logout_button.setTitleEdgeInsets UIEdgeInsetsMake(0.0, 20, 0.0, 0.0)

      logout_button.addTarget(target,
                             action: "show_logout:",
                             forControlEvents: UIControlEventTouchUpInside)

      addSubview(logout_button)
    end
  end
end
