class TempAlert
  def self.alert(text, positive = true)
    type = positive ? MBAlertViewHUDTypeCheckmark : MBAlertViewHUDTypeExclamationMark
    MBHUDView.hudWithBody text, type:type, hidesAfter:1.0, show: true
  end
end
