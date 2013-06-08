describe Heroku do
  describe "login" do
    it "returns with a 200" do
      #@semaphore = Dispatch::Semaphore.new(0)
      @response = nil
      Heroku.new.login("yannick.schutz@gmail.com", "jesuis19MARS06@&*") do |response|
        @response = response
        #@semaphore.signal
      end
      #@semaphore.wait
      sleep 10
      @response.should.be.ok
    end
  end

end
