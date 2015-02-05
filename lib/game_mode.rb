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

    if(player_this_turn.pawns.include?(:"#{pawn_name}") == false)
      return "Cannot select enemy pawn!"
    else
      pawn_to_select = player_this_turn.pawns[:"#{pawn_name}"]
    end 

    roll_to_finish = player_this_turn.path.size - pawn_to_select.path_pos - 1

    if(player_this_turn.last_roll != 6 && !pawn_to_select.is_active)
      return "Cannot select this pawn. You need to roll 6!"
    elsif(pawn_to_select.is_active && pawn_to_select.path_pos >= 40 && roll_to_finish < player_this_turn.last_roll)
      return "You need to roll #{roll_to_finish} to use this pawn"
    else
      @selected_pawn = pawn_to_select
    end
  end

  def activate_pawn
    if(@selected_pawn.name)
      pawn_pos = @selected_pawn.pos
      start_pos = @players[:"#{@turn}"].start_pos

      @board[pawn_pos[0]][pawn_pos[1]] = ""
      @players[:"#{@turn}"].activate_pawn(@selected_pawn.name)
      @board[start_pos[0]][start_pos[1]] = @selected_pawn.name
      
    else
      puts "Please select a pawn"
    end
  end

  def move_pawn
    pawn_pos = @selected_pawn.pos
    player_this_turn = @players[:"#{@turn}"]

    @board[pawn_pos[0]][pawn_pos[1]] = ""
    player_this_turn.move_pawn(@selected_pawn.name, player_this_turn.last_roll)

    handle_if_pawn_finished
    next_turn
  end

  def handle_if_pawn_finished
    pawn_new_pos = @selected_pawn.pos
    player_this_turn = @players[:"#{@turn}"]

    if(pawn_new_pos == [5, 5])
      puts
      puts "Pawn #{@selected_pawn.name} finished"
      player_this_turn.finish_pawn(@selected_pawn.name)
    else
      @board[pawn_new_pos[0]][pawn_new_pos[1]] = @selected_pawn.name
    end
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