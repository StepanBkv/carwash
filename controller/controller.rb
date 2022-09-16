require_relative '../model/model'

class Controller
  def initialize
    @model = Model.new
  end

  def get_list_client
    @model.get_list_client
  end

  def get_list_client_worker
    @model.get_list_client_worker
  end

  def select_item_table
    @model.select_item_table
  end
  def update_item_table coordinate
    @model.update_item_table coordinate
  end

  def delete_item_table coordinate
    @model.delete_item_table coordinate
  end

  def add_item_table new_item_table
    @model.add_item_table new_item_table
  end
  def search_item text
    @model.search_item text
  end

  def price_sum_month
    @model.price_sum_month
  end

  def price_sum_day
    @model.price_sum_day
  end

  def year
    @model.year
  end

  def month
    @model.month
  end

  def day
    @model.day
  end

end