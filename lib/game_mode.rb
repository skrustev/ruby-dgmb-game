require_relative './player'

class GameMode
  attr_reader  :board, :turn, :players, :selected_pawn
  def initialize(start_turn = "player1", players = {})
    @board =
      [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], ["b:1"], [], []],
       [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
       [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
    @players = players
    @turn = start_turn
    @turn_sequence = []
    @selected_pawn = Pawn.new

    set_turn_sequence
  end

  def set_turn_sequence(turn_sequence = nil)
    if turn_sequence
      @turn_sequence = turn_sequence
    else
      @players.each do |player_name, object|
        @turn_sequence << player_name.to_s
      end
    end
  end

  def next_turn
    if(@turn_sequence.index(@turn) == @turn_sequence.size - 1)
      @turn = @turn_sequence[0]
    else
      index_next_turn = @turn_sequence.index(@turn) + 1
      @turn = @turn_sequence[index_next_turn]
    end
  end

  def add_player(player)
    @players[:"player#{players.size + 1}"] = player

    unless @turn_sequence.include?("player#{players.size + 1}")
      @turn_sequence << "player#{players.size + 1}"
    end
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

  def activate_selected_pawn
    if(@selected_pawn.name)
      pawn_pos = @selected_pawn.pos
      start_pos = @players[:"#{@turn}"].start_pos

      @board[pawn_pos[0]][pawn_pos[1]].delete(@selected_pawn.name)
      @players[:"#{@turn}"].activate_pawn(@selected_pawn.name)
      handle_if_steps_on_pawn(start_pos)
    else
      puts "Please select a pawn"
    end
  end

  def move_selected_pawn
    pawn_pos = @selected_pawn.pos
    player_this_turn = @players[:"#{@turn}"]

    if @selected_pawn.is_active
      @board[pawn_pos[0]][pawn_pos[1]].delete(@selected_pawn.name)
      player_this_turn.move_pawn(@selected_pawn.name, player_this_turn.last_roll)
    else
      return "You need to activate this pawn first"
    end

    handle_if_pawn_finished
    handle_next_turn
  end

  #can accept just string for one name to destroy or array of strings
  def destroy_pawns(pawn_names_array, at_position)
    #this is done for safety reasons, otherwise it gets eaten when iterating through it if being array
    pawns_to_destroy = pawn_names_array.dup

    pawn_owner =  case pawn_names_array[0][0]
                  when 'b' then @players[:"player1"]
                  when 'r' then @players[:"player2"]
                  when 'y' then @players[:"player3"]
                  when 'g' then @players[:"player4"]
                  end

    #check if it is single string or array of strings
    if pawns_to_destroy.is_a?(String)
      board[at_position[0]][at_position[1]].delete(pawns_to_destroy)
      default_pos = pawn_owner.destroy_pawn(pawns_to_destroy)
      @board[default_pos[0]][default_pos[1]] << pawns_to_destroy
    elsif pawns_to_destroy.is_a?(Array)
      pawns_to_destroy.each do |pawn_name|
        board[at_position[0]][at_position[1]].delete(pawn_name)
        default_pos = pawn_owner.destroy_pawn(pawn_name)
        @board[default_pos[0]][default_pos[1]] << pawn_name
      end
    end
    
  end

  def override_turn(new_player_turn)
    @turn = new_player_turn
  end

  def have_winner
    result = [false, ""]
    @players.each do |name, player|
      if player.finished_pawns == 4
        result = [true, player.name]
        return result
      end
    end

    result
  end

  def restart_game
    @players.each do |name, player|
      player.reset
    end

    @turn = @turn_sequence[0]
    @board =
      [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], ["b:1"], [], []],
       [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
       [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]
  end

  def clear_game
    @board =
      [[[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], ["r:0"], ["r:1"], [], [], [], [], [], [], [], ["b:0"], ["b:1"], [], []],
       [[], [], ["r:2"], ["r:3"], [], [], [], [], [], [], [], ["b:2"], ["b:3"], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], ["X"], [], ["X"], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], ["X"], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], ["y:0"], ["y:1"], [], [], [], [] , [], [], [], ["g:0"], ["g:1"], [], []],
       [[], [], ["y:2"], ["y:3"], [], [], [], [] , [], [], [], ["g:2"], ["g:3"], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []],
       [[], [], [], [], [], [], [], [], [], [], [], [], [], [], []]]

    @players = {}
    @turn = "player1"
    @turn_sequence = []
    @selected_pawn = Pawn.new
  end

private
  def handle_if_pawn_finished
    pawn_new_pos = @selected_pawn.pos
    player_this_turn = @players[:"#{@turn}"]

    if @board[pawn_new_pos[0]][pawn_new_pos[1]] == ["X"]
      puts
      puts "Pawn #{@selected_pawn.name} finished"
      player_this_turn.finish_pawn(@selected_pawn.name)
    else
      handle_if_steps_on_pawn(pawn_new_pos)
    end
  end

  def handle_if_steps_on_pawn(on_position)
    if board[on_position[0]][on_position[1]].size > 0
      first_pawn_on_position = board[on_position[0]][on_position[1]][0]
    else
      first_pawn_on_position = board[on_position[0]][on_position[1]]
    end

    player_this_turn = @players[:"#{@turn}"]

    unless board[on_position[0]][on_position[1]].empty? || player_this_turn.pawns.include?(:"#{first_pawn_on_position}")
      pawns_to_destroy = board[on_position[0]][on_position[1]]
      destroy_pawns(pawns_to_destroy, on_position)
    end

    @board[on_position[0]][on_position[1]] << @selected_pawn.name
  end

  def handle_next_turn
    player_this_turn = @players[:"#{@turn}"]
    if player_this_turn.last_roll == 6
      "You can roll once more"
    else
      next_turn
    end
  end
end