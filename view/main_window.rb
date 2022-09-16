require 'fox16'
require_relative '../controller/controller'
require_relative 'autorize_window'
include Fox

class Main_window < FXMainWindow
  def initialize app
    gsm = Fiddle::Function.new(Fiddle::dlopen("user32")["GetSystemMetrics"], [Fiddle::TYPE_LONG],Fiddle::TYPE_LONG)
    x= gsm.call(0)
    y= gsm.call(1)
    super(app, "Статус", :width => x, :height => y.to_i - 50)
    @controller = Controller.new
    self.backColor = "white"
    @list_client_worker = @controller.get_list_client_worker

    tabbook = FXTabBook.new(self, :opts => LAYOUT_FILL)
    basics_tab = FXTabItem.new(tabbook, "Работник", :height => 30, :width => 165, :opts => LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH)
    basics_page = FXVerticalFrame.new(tabbook,
                                      :opts => FRAME_RAISED|LAYOUT_FILL)
    admin_tab = FXTabItem.new(tabbook, "Админ", :height => 30, :width => 165, :opts => LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH)
    admin_page = FXVerticalFrame.new(tabbook,
                                     :opts => FRAME_RAISED|LAYOUT_FILL)
    info_tab = FXTabItem.new(tabbook, "Инфо", :height => 30, :width => 165, :opts => LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH)
    info_page = FXVerticalFrame.new(tabbook,
                                      :opts => FRAME_RAISED|LAYOUT_FILL)
    basics_tab.backColor= admin_tab.backColor = info_tab.backColor = 'blue'
    basics_tab.textColor = admin_tab.textColor = info_tab.textColor = 'white'
    basics_tab.setFont(FXFont.new(app, "Times,125,bold"))
    admin_tab.setFont(FXFont.new(app, "Times,125,bold"))
    info_tab.setFont(FXFont.new(app, "Times,125,bold"))
    create_admin_page admin_page, admin_tab
    admin_tab.disable
    width_minus = (self.width/14)*6

    basics_page.backColor = 'white'
    width_element_window = 167

    label1 = FXLabel.new(basics_page, "Гос.Номер:", :height => 20, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH|LAYOUT_FIX_X|LAYOUT_FIX_Y,
                         :x => self.width/2 - width_minus, :y => 60)
    text1 = FXTextField.new(basics_page, 20, :height => 20, :width => width_element_window,:opts => LAYOUT_CENTER_X|LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH|LAYOUT_FIX_X|LAYOUT_FIX_Y,
                            :x => self.width/2 - width_minus, :y => label1.getY + 25)
    label2 = FXLabel.new(basics_page, "Цена:", :height => 20, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH|LAYOUT_FIX_X|LAYOUT_FIX_Y,
                         :x => self.width/2 - width_minus, :y => text1.getY + 25)
    text2 = FXTextField.new(basics_page, 20, :height => 20, :width => width_element_window,:opts => LAYOUT_CENTER_X|LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH|LAYOUT_FIX_X|LAYOUT_FIX_Y,
                            :x => self.width/2 - width_minus, :y => label2.getY + 25)
    label3 = FXLabel.new(basics_page, "Тип кузова:", :height => 20, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH|LAYOUT_FIX_X|LAYOUT_FIX_Y,
                         :x => self.width/2 - width_minus, :y => text2.getY + 25)
    states = FXComboBox.new(basics_page, 4, :height => 40, :width => width_element_window,
                            :opts => COMBOBOX_NO_REPLACE|COMBOBOX_NORMAL | FRAME_SUNKEN | FRAME_THICK | LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH|LAYOUT_FIX_X|LAYOUT_FIX_Y,
                            :x => self.width/2 - width_minus, :y =>label3.getY + 25 )
    states.appendItem("Седан класс 1")
    states.appendItem("Седан класс 2")
    states.appendItem("Кроссовер")
    states.appendItem("Внедорожник")
    states.numVisible = 4
    states.setFont(FXFont.new(app, "Times,125,bold"))
    states.selTextColor  = 'white'
    states.selBackColor = 'blue'
    states.hiliteColor = 'blue'
    @type_auto = { 0 => "Седан класс 1" }
    states.connect(SEL_COMMAND) do |sender, sel, data|
      @type_auto = { sender.currentItem => sender.text }
    end
    @titles = FXDataTarget.new(true)
    groupbox = FXGroupBox.new(basics_page, "Выбор услуг.", :height => 140, :width => width_element_window, :opts => GROUPBOX_NORMAL | FRAME_GROOVE | LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH|LAYOUT_FIX_X|LAYOUT_FIX_Y,
                              :x => self.width/2 - width_minus, :y => states.getY + states.getHeight + 5)
    checkbutton_1 = FXCheckButton.new(groupbox, "Кузов", :target => @titles, :selector => FXDataTarget::ID_VALUE)
    checkbutton_2 = FXCheckButton.new(groupbox, "Салон")
    checkbutton_3 = FXCheckButton.new(groupbox, "Обдув с водой")
    checkbutton_4 = FXCheckButton.new(groupbox, "Обдув с пеной")

    groupbox_radio = FXGroupBox.new(basics_page, "Выбор оплаты:", :height => 90, :width => width_element_window, :opts => GROUPBOX_NORMAL | FRAME_GROOVE | LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                                    :x => self.width / 2 - width_minus, :y => groupbox.getY + groupbox.getHeight + 5)
    radio1 = FXRadioButton.new(groupbox_radio, "Наличный" ,
                               :target => @choice, :selector => FXDataTarget::ID_OPTION)
    radio2 = FXRadioButton.new(groupbox_radio, "Безналичный" ,
                               :target => @choice, :selector => FXDataTarget::ID_OPTION+1)
    groupbox_radio.textColor = 'white'
    groupbox_radio.backColor = 'blue'
    groupbox_radio.setFont(FXFont.new(app, "Times,125,bold"))
    check_but_list = [radio1, radio2]
    check_but_list.each { |i| i.textColor = 'white'; i.backColor = 'blue'; i.setFont(FXFont.new(app, "Times,110,bold")) }

    groupbox.textColor = 'white'
    groupbox.backColor = 'blue'
    groupbox.setFont(FXFont.new(app, "Times,125,bold"))
    check_but_list = [checkbutton_1, checkbutton_2, checkbutton_3, checkbutton_4]
    check_but_list.each { |i| i.textColor = 'white'; i.backColor = 'blue'; i.setFont(FXFont.new(app, "Times,110,bold"))}
    button_1 = FXButton.new(basics_page, "Сохранить", :height => 50, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH|LAYOUT_FIX_X|LAYOUT_FIX_Y,
                            :x => self.width/2 -width_minus, :y => groupbox_radio.getY + groupbox_radio.getHeight + 5)
    button_1.backColor = 'blue'
    button_1.textColor = "white"
    button_2 = FXButton.new(basics_page, "Найти", :height => 50, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH|LAYOUT_FIX_X|LAYOUT_FIX_Y,
                            :x => self.width/2 - width_minus, :y => button_1.getY + 55)
    button_3 = FXButton.new(basics_page, "Войти как администратор", :height => 45, :width => 220, :opts =>LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH|LAYOUT_FIX_X|LAYOUT_FIX_Y,
                            :x => self.width - 220, :y => 0)
    button_2.backColor = 'blue'
    button_2.textColor = "white"
    button_3.backColor = 'blue'
    button_3.textColor = "white"
    label1.backColor = label2.backColor = label3.backColor = 'blue'
    label1.textColor = label2.textColor = label3.textColor = 'white'

    button_1.setFont(FXFont.new(app, "Times,125,bold"))
    button_2.setFont(FXFont.new(app, "Times,125,bold"))
    button_3.setFont(FXFont.new(app, "Times,125,bold"))
    text1.backColor = text2.backColor = 'grey'
    @table = FXTable.new(basics_page, :height => (self.height / 10) * 9, :width => (self.width ) , :opts => LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_RIGHT | LAYOUT_SIDE_BOTTOM | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                           :x => self.width / 5 +9, :y => (self.height / 15) + 13)
    @table.setTableSize(@list_client_worker.size, 9)
    @table.editable = false
    self.update_window @list_client_worker, @table
    @table.tableStyle |= TABLE_NO_COLSELECT

    button_1.connect(SEL_COMMAND) do |sender, sel, data|
      unless text1.text == '' and text2.text == ''
        message = @controller.add_item_table [text1.text.chomp.upcase, text2.text, @type_auto, @service, @choice.value]
        if message == "ок"
          text1.text = text2.text = ''
          @list_client_worker = @controller.get_list_client_worker
          self.clear_window @list_client_worker.size, @table
          self.update_window @list_client_worker, @table

          @list_client_global = self.get_list_client
          self.clear_window  @list_client_global.size, @table_2
          self.update_window  @list_client_global, @table_2
          message = "Запись добавлена!"
          list_check = [checkbutton_1, checkbutton_2, checkbutton_3, checkbutton_4]
          @service = {}
          list_check.each { |i| i.checkState = false }
          @label6.text = "Прибыль сотруднику: #{(self.price_sum_month*35)/100}p."
          @label5.text = "Выручка за месяц: #{self.price_sum_month}p."
          @label4.text = "Выручка за день: #{self.price_sum_day}p."
          message_ok(message)
        else
          message_error(message)
        end
      end
    end

    button_2.connect(SEL_COMMAND) do |sender, sel, data|
      if text1.text != ''
        col_item = @controller.search_item(text1.text.chomp.upcase)
        if col_item != 0
          message = "Этот клиент был у нас #{col_item} раз!"
          text1.text = ''
          message_ok(message)
        else
          message_error("Нет такой записи!")
        end
      end
    end

    button_3.connect(SEL_COMMAND) do |sender, sel, data|
      autorize = Autorize_window.new app, admin_tab
      autorize.create
    end

    @service = {}

    checkbutton_1.connect(SEL_COMMAND) do |sender, sel, data|
      if checkbutton_1.checked?
        @service[0] = sender.text
      end
      if checkbutton_1.unchecked?
        @service.delete(0)
      end
    end

    checkbutton_2.connect(SEL_COMMAND) do |sender, sel, data|
      if checkbutton_2.checked?
        @service[1] = sender.text
      end
      if checkbutton_2.unchecked?
        @service.delete(1)
      end
    end
    checkbutton_3.connect(SEL_COMMAND) do |sender, sel, data|
      if checkbutton_3.checked?
        @service[2] = sender.text
      end
      if checkbutton_3.unchecked?
        @service.delete(2)
      end
    end
    checkbutton_4.connect(SEL_COMMAND) do |sender, sel, data|
      if checkbutton_4.checked?
        @service[3] = sender.text
      end
      if checkbutton_4.unchecked?
        @service.delete(3)
      end
    end
    #____________________________________ADMIN________________________________

  end

  def update_window list_client, table
    if list_client.size != 0
      j = -1
      table.setTableSize(list_client.size, 10)
      for i in list_client
        table.setColumnText(0, 'Гос. Номер')
        table.setColumnText(1, 'Цена')
        table.setColumnText(2, 'Доп.цена')
        table.setColumnText(3, "Cпособ опл.")
        table.setColumnText(4, 'Время')
        table.setColumnText(5, 'Дата')
        table.setColumnText(6, 'Тип кузова')
        table.setColumnText(7, 'Услуги')
        table.setRowText(j + 1, (j + 2).to_s)
        table.setItemText(j + 1, 0, i.state_number)
        table.setItemText(j + 1, 1, i.price)
        table.setItemText(j + 1, 2, i.add_price)
        table.setItemText(j + 1, 3, i.pay_ment)
        table.setItemText(j + 1, 4, i.time.to_s.split[1])
        table.setItemText(j + 1, 5, i.time.to_s.split[0])
        table.setItemText(j + 1, 6, i.type_auto)
        table.setItemJustify(j + 1, 6, FXTableItem::CENTER_X)
        table.setItemText(j + 1, 7, i.service)
        table.setItemJustify(j + 1, 7, FXTableItem::CENTER_X)
        spanning_item = table.getItem(j + 1, 7)
        table.setItem(j + 1, 8, spanning_item)
        table.setItem(j + 1, 9, spanning_item)
        j += 1
      end
    end
  end

  def clear_window list_client, table
    if list_client != 0
      j = -1
      for i in 1..list_client - 1
        table.setRowText(j + 1, '')
        table.setItemText(j + 1, 0, '')
        table.setItemText(j + 1, 1, '')
        table.setItemText(j + 1, 2, '')
        table.setItemText(j + 1, 3, '')
        table.setItemText(j + 1, 4, '')
        table.setItemText(j + 1, 5, '')
        table.setItemText(j + 1, 6, '')
        table.setItemText(j + 1, 7, '')
        table.setItemText(j + 1, 8, '')
        table.setItemText(j + 1, 9, '')
        j += 1
      end
    else
      table.setRowText(0, '')
      table.setItemText(0, 0, '')
      table.setItemText(0, 1, '')
      table.setItemText(0, 2, '')
      table.setItemText(0, 3, '')
      table.setItemText(0, 4, '')
      table.setItemText(0, 5, '')
      table.setItemText(0, 6, '')
      table.setItemText(0, 7, '')
      table.setItemText(0, 8, '')
      table.setItemText(0, 9, '')
    end
  end

  def create_admin_page admin_page, admin_tab
    width_element_window = 166
    width_minus = (self.width/14)*6
    @list_client_global = self.get_list_client
    label1 = FXLabel.new(admin_page, "Гос.Номер:", :height => 20, :width => width_element_window, :opts => LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                         :x => self.width / 2 - width_minus, :y => 60)
    text1 = FXTextField.new(admin_page, 20, :height => 20, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                            :x => self.width / 2 - width_minus, :y => label1.getY + 25)
    label2 = FXLabel.new(admin_page, "Цена:", :height => 20, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                         :x => self.width / 2 - width_minus, :y => text1.getY + 25)
    text2 = FXTextField.new(admin_page, 20, :height => 20, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                            :x => self.width / 2 - width_minus, :y => label2.getY + 25)
    label3 = FXLabel.new(admin_page, "Тип кузова:", :height => 20, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                         :x => self.width / 2 - width_minus, :y => text2.getY + 25)
    @label4 = FXLabel.new(admin_page, "Выручка за день: #{
      if @list_client_global != [];
        @controller.price_sum_day
      else
        0
      end}p.", :height => 40, :width => 260, :opts => JUSTIFY_LEFT | LAYOUT_SIDE_TOP | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH)

    @label5 = FXLabel.new(admin_page, "Выручка за месяц: #{
      if @list_client_global != [];
        @controller.price_sum_month
      else
        0
      end}p.", :height => 40, :width => 260, :x => @label4.width + @label4.getX + 20, :y => 5, :opts => JUSTIFY_LEFT | LAYOUT_SIDE_TOP | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH| LAYOUT_FIX_X | LAYOUT_FIX_Y)

    @label6 = FXLabel.new(admin_page, "Прибыль сотруднику: #{
      if @list_client_global != [];
        (self.price_sum_month*35) / 100
      else
        0
      end}p.", :height => 40, :width => 260, :x => @label5.width + @label5.getX + 20, :y => 5, :opts => JUSTIFY_LEFT | LAYOUT_SIDE_TOP | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH| LAYOUT_FIX_X | LAYOUT_FIX_Y)

    label7 = FXLabel.new(admin_page, "Аренда за месяц: #{
      25000}p.", :height => 40, :width => 260, :x => @label6.width + @label6.getX + 20, :y => 5, :opts =>  LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y)

    states = FXComboBox.new(admin_page, 4, :height => 40, :width => width_element_window,
                            :opts => COMBOBOX_NO_REPLACE | COMBOBOX_NORMAL | FRAME_SUNKEN | FRAME_THICK | LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                            :x => self.width / 2 - width_minus, :y => label3.getY + 25)
    states.appendItem("Седан класс 1")
    states.appendItem("Седан класс 2")
    states.appendItem("Кроссовер")
    states.appendItem("Внедорожник")
    states.numVisible = 4
    states.setFont(FXFont.new(app, "Times,125,bold"))
    states.selTextColor = 'white'
    states.selBackColor = 'blue'
    states.hiliteColor = 'blue'
    @type_auto = { 0 => "Седан класс 1" }
    states.connect(SEL_COMMAND) do |sender, sel, data|
      @type_auto = { sender.currentItem => sender.text }
    end

    groupbox = FXGroupBox.new(admin_page, "Выбор услуг.", :height => 140, :width => width_element_window, :opts => GROUPBOX_NORMAL | FRAME_GROOVE | LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                                :x => self.width / 2 - width_minus, :y => states.getY + states.getHeight + 5)
    checkbutton_1 = FXCheckButton.new(groupbox, "Кузов")
    checkbutton_2 = FXCheckButton.new(groupbox, "Салон")
    checkbutton_3 = FXCheckButton.new(groupbox, "Обдув с водой")
    checkbutton_4 = FXCheckButton.new(groupbox, "Обдув с пеной")
    groupbox.textColor = 'white'
    groupbox.backColor = 'blue'
    groupbox.setFont(FXFont.new(app, "Times,125,bold"))
    check_but_list = [checkbutton_1, checkbutton_2, checkbutton_3, checkbutton_4]
    check_but_list.each { |i| i.textColor = 'white'; i.backColor = 'blue'; i.setFont(FXFont.new(app, "Times,110,bold")) }
    @choice = FXDataTarget.new(0)

    groupbox_radio = FXGroupBox.new(admin_page, "Выбор оплаты:", :height => 90, :width => width_element_window, :opts => GROUPBOX_NORMAL | FRAME_GROOVE | LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                              :x => self.width / 2 - width_minus, :y => groupbox.getY + groupbox.getHeight + 5)
    radio1 = FXRadioButton.new(groupbox_radio, "Наличный" ,
                               :target => @choice, :selector => FXDataTarget::ID_OPTION)
    radio2 = FXRadioButton.new(groupbox_radio, "Безналичный" ,
                               :target => @choice, :selector => FXDataTarget::ID_OPTION+1)
    groupbox_radio.textColor = 'white'
    groupbox_radio.backColor = 'blue'
    groupbox_radio.setFont(FXFont.new(app, "Times,125,bold"))
    check_but_list = [radio1, radio2]
    check_but_list.each { |i| i.textColor = 'white'; i.backColor = 'blue'; i.setFont(FXFont.new(app, "Times,110,bold")) }

    @choice.connect(SEL_COMMAND) do
      puts "The newly selected value is #{@choice.value}"
    end

    button_1 = FXButton.new(admin_page, "Сохранить", :height => 40, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                            :x => self.width / 2 - width_minus, :y => groupbox_radio.getY + groupbox_radio.getHeight + 5)
    button_2 = FXButton.new(admin_page, "Найти", :height => 40, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                            :x => self.width / 2 - width_minus, :y => button_1.getY + button_1.getHeight + 5)
    button_3 = FXButton.new(admin_page, "Удалить", :height => 40, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                            :x => self.width / 2 - width_minus, :y => button_2.getY + button_2.getHeight + 5)
    button_4 = FXButton.new(admin_page, "Выйти", :height => 45, :width => 120, :opts =>LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH|LAYOUT_FIX_X|LAYOUT_FIX_Y,
                            :x => self.width - 120, :y => 0)
    button_list = [button_1, button_2, button_3, button_4]
    button_list.each {|i| i.backColor = 'blue'; i.textColor = 'white'; i.setFont(FXFont.new(app, "Times,125,bold"))}
    label_list = [label1, label2,label3]
    label_list.each {|i| i.backColor = 'blue'; i.textColor = 'white'}
    label_list = [@label4,@label5, @label6, label7]
    label_list.each{|i| i.setFont(FXFont.new(app, "Times,125,bold")); i.backColor = 'blue'; i.textColor = "white"}
    label7.backColor = 'red'
    label7.textColor = 'black'
    text_list = [text1, text2]
    text_list.each {|i| i.backColor = 'grey'}

    @table_2 = FXTable.new(admin_page, :height => (self.height / 10) * 9, :width => (self.width ) , :opts => LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_RIGHT | LAYOUT_SIDE_BOTTOM | LAYOUT_FIX_X | LAYOUT_FIX_Y,
                           :x => self.width / 5 + 9, :y => (self.height / 15) + 13)
    @table_2.setTableSize(@list_client_global.size, 9)
    @table_2.editable = false
    self.update_window @list_client_global, @table_2
    @table_2.tableStyle |= TABLE_NO_COLSELECT
    @selected_item_2 = []

    @table_2.connect(SEL_SELECTED) do |sender, sel, pos|
      if @selected_item_2.size >= 3
        @selected_item_2.clear
      end
      @selected_item_2 << [pos.row, pos.col]
    end

    @table_2.connect(SEL_DESELECTED) do |sender, sel, pos|
      @selected_item_2.delete([pos.row, pos.col])
    end

    day = @controller.day
    app.addTimeout(1000, :repeat => true) do
      if day != @controller.day
        day = @controller.day
        @controller.month
        @controller.year
        self.clear_window @list_client_worker.size + 1, @table
        @list_client_worker = @controller.get_list_client_worker
        self.update_window @list_client_worker, @table
        @label4.text = "Выручка за день: #{self.price_sum_day}p."
        @label5.text = "Выручка за месяц: #{self.price_sum_month}p."
        @label6.text = "Прибыль сотруднику: #{(self.price_sum_month*35)/100}p."
      end
    end

    button_1.connect(SEL_COMMAND) do |sender, sel, data|
      unless text1.text == '' and text2.text == ''
        message = @controller.add_item_table [text1.text.chomp.upcase, text2.text, @type_auto, @service,  @choice.value]
        if message == "ок"
          text1.text = text2.text = ''
          @list_client_global = self.get_list_client
          self.clear_window  @list_client_global.size, @table_2
          self.update_window  @list_client_global, @table_2

          @list_client_worker = @controller.get_list_client_worker
          self.clear_window @list_client_worker.size, @table
          self.update_window @list_client_worker, @table

          message = "Запись добавлена!"
          @label6.text = "Прибыль сотруднику: #{(self.price_sum_month*35)/100}p."
          @label5.text = "Выручка за месяц: #{self.price_sum_month}p."
          @label4.text = "Выручка за день: #{self.price_sum_day}p."
          list_check = [checkbutton_1, checkbutton_2, checkbutton_3, checkbutton_4]
          @service = {}
          list_check.each { |i| i.checkState = false }
          message_ok(message)
        else
          message_error(message)
        end
      end
    end

    button_2.connect(SEL_COMMAND) do |sender, sel, data|
      if text1.text != ''
        col_item = @controller.search_item(text1.text.chomp.upcase)
        if col_item != 0
          message = "Этот клиент был у нас #{col_item} раз!"
          text1.text = ''
          message_ok(message)
        else
          message_error("Нет такой записи!")
        end
      end
    end

    button_3.connect(SEL_COMMAND) do |sender, sel, data|
      if @selected_item_2 != []
        @controller.delete_item_table @selected_item_2
        @list_client_global = self.get_list_client
        self.clear_window  @list_client_global.size, @table_2
        self.update_window  @list_client_global, @table_2

        @list_client_worker = @controller.get_list_client_worker
        self.clear_window @list_client_worker.size, @table
        self.update_window @list_client_worker, @table
        message_ok("Вы удалили запись!")
        @selected_item_2 = []
        @label6.text = "Прибыль сотруднику: #{(self.price_sum_month*35)/100}p."
        @label5.text = "Выручка за месяц: #{self.price_sum_month}p."
        @label4.text = "Выручка за день: #{self.price_sum_day}p."
      end
    end

    button_4.connect(SEL_COMMAND) do |sender, sel, data|
      admin_tab.disable
      message_ok("Вы вышли!")
    end

    @service = {}

    checkbutton_1.connect(SEL_COMMAND) do |sender, sel, data|
      if checkbutton_1.checked?
        @service[0] = sender.text
      end
      if checkbutton_1.unchecked?
        @service.delete(0)
      end
    end

    checkbutton_2.connect(SEL_COMMAND) do |sender, sel, data|
      if checkbutton_2.checked?
        @service[1] = sender.text
      end
      if checkbutton_2.unchecked?
        @service.delete(1)
      end
    end

    checkbutton_3.connect(SEL_COMMAND) do |sender, sel, data|
      if checkbutton_3.checked?
        @service[2] = sender.text
      end
      if checkbutton_3.unchecked?
        @service.delete(2)
      end
    end

    checkbutton_4.connect(SEL_COMMAND) do |sender, sel, data|
      if checkbutton_4.checked?
        @service[3] = sender.text
      end
      if checkbutton_4.unchecked?
        @service.delete(3)
      end
    end
  end

  def create
    super
    show PLACEMENT_SCREEN
  end

  def get_list_client
    @controller.get_list_client
  end

  def select_item_table
    @controller.select_item_table
  end

  def price_sum_month
    @controller.price_sum_month
  end

  def price_sum_day
    @controller.price_sum_day
  end

  def message_ok message
    FXMessageBox.information(
      self,
      MBOX_OK,
      "Сообщение!",
      message
    )
  end

  def message_error message
    FXMessageBox.warning(
      self,
      MBOX_OK,
      "Сообщение!",
      message
    )
  end
end

if __FILE__ == $0
  FXApp.new do |app|
    Main_window.new app
    app.create
    app.run
  end
end

