class ConfigView < UITableViewCell
  include BW::KVO

  attr_accessor :config

  def init
    initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:"ADDON").tap do
      textLabel.textColor = 0x20404B.uicolor
      textLabel.backgroundColor = :clear.uicolor
      contentView.backgroundColor = :clear.uicolor

      detailTextLabel.textColor = 0x4C6673.uicolor
      detailTextLabel.backgroundColor = :clear.uicolor

      bg_view = UIView.alloc.init
      bg_view.setBackgroundColor 0xD3C7B9.uicolor
      setSelectedBackgroundView bg_view

      observe(self, :config) do |_, new_config|
        textLabel.text = new_config.key.to_s.downcase
        detailTextLabel.text = new_config.value.to_s
      end
    end
  end
end

