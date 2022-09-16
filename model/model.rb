require_relative '../note_list'
require_relative '../client'
require_relative '../client_list'
require 'yaml'

class Model
  def initialize
    @@year = Client.get_now_date[0]
    @@month = Client.get_now_date[1]
    @@day = Client.get_now_date[2]
  end

  def get_list_client
    @client_list = ClientList.read_from_YAML("./client_list.yaml")
  end

  def get_list_client_worker
    @client_list = ClientList.read_from_YAML("./client_list.yaml")
    client_list_worker = []
    for i in @client_list
      if i.time.inspect.split[0] == "#{@@year}-#{@@month}-#{@@day}"
        client_list_worker.push(i)
    end
    end
    client_list_worker
  end

  def update_item_table coordinate
    print coordinate
  end

  def delete_item_table coordinate
      @client_list.choose_note = coordinate[0][0]
      @client_list.delete_note
      ClientList.write_to_YAML('./client_list.yaml', @client_list)
  end

  def add_item_table new_item_table
    message = "ок"
    begin
      Client.state_number = new_item_table[0]
      Client.price = new_item_table[1]
    rescue StateNumberError
      message = "Не правильный Гос.Номер!"
      return message
    rescue PriceError
      message = "Не правильно задана цена!"
      return message
    end
    if new_item_table[1] == ""
      new_item_table[1] = "0"
    end
    @client_list.add_note(new_item_table)
    ClientList.write_to_YAML('./client_list.yaml', @client_list)
    message
  end

  def search_item text
    get_list_client
    number = 0
    if @client_list.size != 0
    for i in @client_list
      if i.state_number.upcase == text
        number += 1
      end
    end
    end
    number
  end

  def price_sum_month
    get_list_client
    sum = 0
    for i in @client_list
      if i.time.inspect.split[0].split('-')[1] == @@month and i.time.inspect.split[0].split('-')[0] == @@year
        sum += i.price.to_i
      end
    end
    sum
  end

  def price_sum_day
    get_list_client
    sum = 0
    if @client_list.size != 0
    for i in @client_list
      if i.time.inspect.split[0] == "#{@@year}-#{@@month}-#{@@day}"
        sum += i.price.to_i
      end
    end
    end
    sum
  end

  def year
    @@year = Client.get_now_date[0]
  end

  def month
    @@month = Client.get_now_date[1]
  end

  def day
    @@day = Client.get_now_date[2]
  end

end
