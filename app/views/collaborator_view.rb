class CollaboratorView < UITableViewCell
  include BW::KVO

  attr_accessor :collaborator

  def init
    initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:"collaborator").tap do
      textLabel.textColor = 0x20404B.uicolor
      textLabel.backgroundColor = :clear.uicolor
      contentView.backgroundColor = :clear.uicolor
      bg_view = UIView.alloc.init
      bg_view.setBackgroundColor 0xD3C7B9.uicolor

      owner_label = UILabel.alloc.initWithFrame(CGRectMake(0, 0, 60, 16))
      owner_label.textColor = 0x4C6673.uicolor
      owner_label.backgroundColor = :clear.uicolor

      selectionStyle = UITableViewCellSelectionStyleGray
      self.accessoryView = owner_label
      self.setSelectedBackgroundView bg_view

      observe(self, :collaborator) do |_, new_collaborator|
        textLabel.text = new_collaborator.email.to_s
        owner_label.text = "(#{new_collaborator.role})" if new_collaborator.role
      end
    end
  end
end


