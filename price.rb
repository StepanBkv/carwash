class Price
  def initialize dop_price, type_auto, service
    @dop_price = dop_price
    @type_auto = type_auto
    @service = service
    @sercive_price_list = { 'Кузов' => 350, 'Салон' => 250, 'Обдув с водой' => 200, 'Обдув с пеной' => 250 }
  end

  def get_price
    (@dop_price.to_i + sum_price_service).to_s
  end

  private def service_price
    @service.map { |key, value| @sercive_price_list.select { |key_1, value_1| key_1 == value } }.map { |i| i.keys[0] = i.values[0] }
  end

  private def get_type_auto price
    if @type_auto.keys[0] == 3 and price == 350
      price += @type_auto.keys[0] * 50 + 100
    elsif @type_auto.keys[0] == 2 and price == 200
        price += (@type_auto.keys[0] - 1) * 50
    else
      price += 50 * @type_auto.keys[0]
    end
    price
  end

  private def sum_price_service
    service_price.map {|i| get_type_auto i }.sum
  end
end

