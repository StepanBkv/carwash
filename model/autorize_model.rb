class Autorize_model
  def initialize
    @login = "8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"
    @password = "2955f24ff51bce9f425c9ad1dbd843da0731c8061a5d4c052544b13c38c8f9c8"
  end

  def autorize login, password
    if @login == login and @password == password
      return "Вы вошли!"
    else
      return "Не правильный логин или пароль!"
    end
  end

end
