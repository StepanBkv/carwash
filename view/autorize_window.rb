require 'fox16'
include Fox
require_relative '../controller/autorize_controller'
require 'digest'

class Autorize_window < FXMainWindow
  def initialize app, tab
    super(app, "Авторизация", :width => 300, :height => 200)
    @controller = Autorize_controller.new
    width_element_window = 166
    width_minus = 100
    label1 = FXLabel.new(self, "Логин:", :height => 20, :width => width_element_window, :opts => LAYOUT_CENTER_X |LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH | LAYOUT_FIX_Y,
                         :y => 20)
    text1 = FXTextField.new(self, 20, :height => 20, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH| LAYOUT_FIX_Y,
                             :y => label1.getY + 25)
    label2 = FXLabel.new(self, "Пароль:", :height => 20, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH| LAYOUT_FIX_Y ,
                          :y => text1.getY + 25)
    text2 = FXTextField.new(self, 20, :height => 20, :width => width_element_window, :opts => TEXTFIELD_PASSWD|LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH| LAYOUT_FIX_Y ,
                             :y => label2.getY + 25)
    button_1 = FXButton.new(self, "Войти", :height => 50, :width => width_element_window, :opts => LAYOUT_CENTER_X | LAYOUT_FIX_HEIGHT | LAYOUT_FIX_WIDTH| LAYOUT_FIX_Y ,
                             :y => text2.getY + text2.getHeight + 5)
    label1.backColor = label2.backColor = button_1.backColor = 'blue'
    label1.textColor = label2.textColor = button_1.textColor  = 'white'

    button_1.setFont(FXFont.new(app, "Times,125,bold"))
    text1.backColor = text2.backColor = 'grey'

    button_1.connect(SEL_COMMAND) do |sender, sel, data|
      message = @controller.autorize(Digest::SHA256.hexdigest(text1.text), Digest::SHA256.hexdigest(text2.text))
      if message == "Вы вошли!"
        message_ok message
        text1.text = text2.text = ""
        self.close
        tab.enable
      else
        message_error message
      end
    end
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

  def create
    super
    show PLACEMENT_SCREEN
  end

end

