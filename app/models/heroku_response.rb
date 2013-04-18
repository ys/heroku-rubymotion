class HerokuResponse
  def initialize(subject)
    @subject = subject
  end

  def ok?
    @subject.ok?
  end

  def json
    BW::JSON.parse @subject.body.to_s
  end

  def status_code
    @subject.status_code
  end

  def error_message
    if ok?
      nil
    else
      json["error"]
    end
  end

end
