require_relative './player'

class GameMode
  attr_reader  :board, :players, :turn, :selected_pawn
  def initialize(start_turn, players = {})
    @board = [["b:0", "b:1", "", "", "", "" , "", "", "", "r:0", "r:1"],
              ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
              ["", "", "", "", "", "" , "", "", "", "", ""],
              ["", "", "", "", "", "" , "", "", "", "", ""],
              ["", "", "", "", "", "" , "", "", "", "", ""],
              ["", "", "", "", "", "" , "", "", "", "", ""],
              ["", "", "", "", "", "" , "", "", "", "", ""],
              ["", "", "", "", "", "" , "", "", "", "", ""],
              ["", "", "", "", "", "" , "", "", "", "", ""],
              ["y:0", "y:1", "", "", "", "" , "", "", "", "g:0", "g:1"],
              ["y:2", "y:3", "", "", "", "" , "", "", "", "g:2", "g:3"]]
    @players = players
    @turn = start_turn
    @selected_pawn = Pawn.new
  end

  def next_turn
    if(@turn[-1] == '4')
      @turn = "player1"
    else
      current = @turn[-1].to_i
      @turn = @turn.chop + "#{current + 1}"
    end
  end

  def add_player(player)
    @players[:"player#{players.size + 1}"] = player
  end

  def select_pawn(name)
    player_this_turn = @players[:"#{@turn}"]

    if(player_this_turn.pawns[:"#{name}" == nil])
      nil
    elsif(player_this_turn.last_roll != 6)
      nil
    else
      @selected_pawn = player_this_turn.pawns[:"#{name}"]
    end
  end

  def activate_pawn
    if(@selected_pawn.name)
      pawn_pos = @selected_pawn.pos
      start_pos = @players[:"#{@turn}"].start_pos

      @players[:"#{@turn}"].activate_pawn(@selected_pawn.name)
      @board[pawn_pos[0]][pawn_pos[1]] = ""
      @board[start_pos[0]][start_pos[1]] = @selected_pawn.name
    else
      puts "Please select a pawn"
    end
  end

end