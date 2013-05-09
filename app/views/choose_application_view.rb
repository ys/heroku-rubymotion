class ChooseApplicationView < UIView

  attr_accessor :target

  def initialize(parent_view)
    initWithFrame(parent_view.bounds).tap do
      self.backgroundColor = 0xD3C7B9.uicolor

      image_view = UIImageView.alloc.initWithFrame([[10, 30],[300, 67]])
      image_view.image = "logo.png".uiimage
      image_view.contentMode = UIViewContentModeScaleToFill
      self.addSubview image_view
      image_view = UIImageView.alloc.initWithFrame([[10, 200],[300, 28]])
      image_view.image = "choose_an_app.png".uiimage
      image_view.contentMode = UIViewContentModeScaleToFill
      self.addSubview image_view
    end
  end
end
