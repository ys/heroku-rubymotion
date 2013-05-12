class AddonView < UITableViewCell
  include BW::KVO

  attr_accessor :addon

  def init
    initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"ADDON").tap do
      textLabel.textColor = 0x20404B.uicolor
      textLabel.backgroundColor = :clear.uicolor
      contentView.backgroundColor = :clear.uicolor
      bg_view = UIView.alloc.init
      bg_view.setBackgroundColor 0xD3C7B9.uicolor

      self.setSelectedBackgroundView bg_view
      observe(self, :addon) do |_, new_addon|
        textLabel.text = new_addon.full_description.to_s
      end
    end
  end
end

