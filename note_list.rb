
class NoteList
    include Enumerable

    @choose_note = nil

    def initialize note_list = []
      @note_list = note_list
    end

    def add_note note_list
      case self.class.name
      when 'ClientList'
        if @note_list != FALSE
          @note_list[@note_list.size] = (Client.new(note_list))
        else
          @note_list = [Client.new(note_list)]
        end
      end
    end

    def change_note note_list
      case self.name
      when "ClientList"
        @note_list[@choose_note] = Client.new(note_list)
      end
    end

    def choose_note
      @choose_note
    end

    def choose_note= choose_note
      if choose_note != -1
        @choose_note = choose_note
      else
        if @note_list.size == 0
          raise("Невозможно выбрать запись! Список пуст")
        else
          @choose_note = 0
        end
      end
    end

    def get_note
      @note_list[@choose_note]
    end

    def delete_note
      @note_list[@choose_note] = nil
      note_list = []
      @note_list.each { |i| note_list << i unless i == nil }
      @note_list = note_list
      self.choose_note = nil
    end

    def size
      size = 0
      if @note_list != FALSE
          for i in @note_list
            size += 1
          end
          return size
        else
          return size
        end
      end

    def each
      for i in @note_list
        yield i
      end
    end

    def sort
      pred = @note_list[0]
      for i in (1..@note_list.size - 1)
        for j in (1..@note_list.size - 1)
          if pred.name > @note_list[j].name
            @note_list[j - 1], @note_list[j] = @note_list[j], @note_list[j - 1]
          end
          pred = @note_list[j]
        end
      end
    end

    def [] value
      @note_list[value]
    end

    def []= value, value2
      @note_list[value] = value2
    end

    def NoteList.read_from_YAML file_name
      self.new(YAML.load_file file_name)
    end

    def NoteList.write_to_YAML file_name, note_list
      File.write file_name, YAML.dump(note_list)
    end
end