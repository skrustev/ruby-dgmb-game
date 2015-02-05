require_relative './player'

class GameMode
  attr_reader  :board, :turn, :players, :selected_pawn
  def initialize(start_turn = "player1", players = {})
    @board = [["b:0", "b:1", "", "", "", "" , "", "", "", "r:0", "r:1"],
              ["b:2", "b:3", "", "", "", "" , "", "", "", "r:2", "r:3"],
              ["", "", "", "", "", "" , "", "", "", "", ""],
              ["", "", "", "", "", "" , "", "", "", "", ""],
              ["", "", "", "", "", "" , "", "", "", "", ""],
              ["", "", "", "", "", "X" , "", "", "", "", ""],
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

  def select_pawn(pawn_name)
    player_this_turn = @players[:"#{@turn}"]

    #check if the current player in turn has such pawn
    if(player_this_turn.pawns.include?(:"#{pawn_name}") == false)
      return "Cannot select enemy pawn!"
    else
      pawn_to_select = player_this_turn.pawns[:"#{pawn_name}"]
    end 

    roll_to_finish = player_this_turn.path.size - pawn_to_select.path_pos - 1

    #check if the desired pawn is not active and the roll is not 6
    if(player_this_turn.last_roll != 6 && !pawn_to_select.is_active)
      return "Cannot select this pawn. You need to roll 6!"
    #check if pawn is in the zone to the finish and the roll is too much
    elsif(pawn_to_select.is_active && pawn_to_select.path_pos >= 40 && roll_to_finish < player_this_turn.last_roll)
      return "You need to roll #{roll_to_finish} to use this pawn"
    #all passed and this pawn can be selected
    else
      @selected_pawn = pawn_to_select
    end
  end

  def activate_pawn
    if(@selected_pawn.name)
      pawn_pos = @selected_pawn.pos
      start_pos = @players[:"#{@turn}"].start_pos

      #remove old record of pawn from board
      @board[pawn_pos[0]][pawn_pos[1]] = ""

      #update pawn position
      @players[:"#{@turn}"].activate_pawn(@selected_pawn.name)

      #update board with new pawn position
      @board[start_pos[0]][start_pos[1]] = @selected_pawn.name
      
    else
      puts "Please select a pawn"
    end
  end

  def move_pawn
    pawn_pos = @selected_pawn.pos

    #remove old record for pawn from board
    @board[pawn_pos[0]][pawn_pos[1]] = ""

    #update pawn position
    player_this_turn = @players[:"#{@turn}"]
    player_this_turn.move_pawn(@selected_pawn.name, player_this_turn.last_roll)

    #check if this pawn just finished
    pawn_new_pos = @selected_pawn.pos
    if(pawn_new_pos == [5, 5])
      #finish pawn if in the finish zone
      player_this_turn.finish_pawn(@selected_pawn.name)
    else
      #update board with new pawn position
      @board[pawn_new_pos[0]][pawn_new_pos[1]] = @selected_pawn.name
    end

    next_turn
  end

  def destroy_pawn(pawn_name, at_position)
    pawn_owner =  case pawn_name[0]
                  when 'b' then @players[:"player1"]
                  when 'y' then @players[:"player2"]
                  when 'g' then @players[:"player3"]
                  when 'r' then @players[:"player4"]
                  end

    @board[at_position[0]][at_position[1]] = ""

    default_pos = pawn_owner.destroy_pawn(pawn_name)

    @board[default_pos[0]][default_pos[1]] = "pawn_name"
  end

  def override_turn(new_player_turn)
    @turn = new_player_turn
  end
end