# class dictating main game flow
class Chess
  def new_game
    @active_player = 'white'
  end

  def switch_player
    @active_player == 'white' ? 'black' : 'white'
  end
end
