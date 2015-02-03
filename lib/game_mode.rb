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
    @players[:"#{@turn}"].pawns[:"#{name}"]
  end
end