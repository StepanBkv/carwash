
class ClientList < NoteList
  def initialize note_list = []
    @note_list = note_list
  end

  def ClientList.read_from_YAML file_name
    super file_name
  end

  def ClientList.write_to_YAML file_name, note_list
    super file_name, note_list
  end
end


