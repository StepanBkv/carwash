require_relative '../model/autorize_model'

class Autorize_controller
  def initialize
    @model = Autorize_model.new()
  end

  def autorize login, password
    @model.autorize(login, password)
  end

end
