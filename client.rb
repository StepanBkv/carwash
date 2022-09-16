require_relative 'state_number_error'
require_relative 'price_error'
require_relative 'price'

class Client
  @@id = 0
  attr_accessor :type_auto, :add_price

  def initialize cli_list
    sum_price = Price.new(cli_list[1], cli_list[2],cli_list[3])
    self.state_number = cli_list[0]
    self.price = sum_price.get_price
    self.add_price = cli_list[1]
    self.type_auto = cli_list[2].values[0]
    self.service = cli_list[3].values
    self.pay_ment = cli_list[4]
    self.time = cli_list[5]
    @id = @@id
    @@id += 1
  end

  def id
    @id
  end

  def service
    if @service != nil
      @service.join (", ")
    else
      return ""
    end
  end

  def service= list_serv
    @service = list_serv
  end

  def state_number
    @state_number
  end

  def state_number= state_number
    valid_state_number state_number
  end

  def valid_state_number state_number
    if state_number.match(/^[а-яА-я]{1}\d{3}[а-яА-Я]{2}\d{2,3}$/)
      @state_number = state_number
    else
      begin
        raise('Не верный Гос.Номер!')
      rescue
        return 'Не верный Гос.Номер!'
      end
    end
  end

  def price
    @price
  end

  def pay_ment= choise
    if choise == 0
      @pay_ment = "Наличный рас."
    else
      @pay_ment = "Безналичный рас."
    end
  end

  def pay_ment
    @pay_ment
  end

  def price= price
    if price == ""
      @price = 0
    else
      if price.match(/^\d+$/)
        @price = price
      else
        begin
          raise('Не верный Гос.Номер!')
        rescue
          return 'Не верный Гос.Номер!'
        end
      end
    end
  end

  def time
    @time
  end

  def time= time
    if time == nil
      date_now = Client.get_now_date
      @time = Time.new(date_now[0], date_now[1], date_now[2], date_now[3], date_now[4], date_now[5])
    else
      @time = time
    end
  end

  def to_s
    "Гос.номер: #{self.state_number}. Время: #{self.time}. Цена: #{self.price}"
  end

  def Client.get_now_date
    now_date = Time.new()
    time = now_date.inspect.split[0].split('-')
    time += now_date.inspect.split[1].split(':')
  end

  def Client.state_number= state_number
    unless state_number.match(/^[а-яА-я]{1}\d{3}[а-яА-Я]{2}\d{2,3}$/)
      raise StateNumberError, 'Не верный Гос.Номер!'
    end
  end

  def Client.price= price
    unless price == ""
      unless price.match(/^\d+$/)
        raise PriceError, "Не правильно задана цена!"
      end
    end
  end
end