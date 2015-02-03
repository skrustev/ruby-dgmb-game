class Pawn 
  attr_reader :name, :player_name, :pos, :initial_pos, 
              :is_active, :is_finished, :can_be_moved

  def initialize(name = nil, player_name = nil, initial_pos = [-1,-1])
    @name = name;
    @player_name = player_name
    @initial_pos = initial_pos
    @pos = @initial_pos
    @is_active = false
    @is_finished = false
    @can_be_moved = false
  end

  def activate(start_pos)
    @pos = start_pos
    @is_active = true
    @can_be_moved = true
  end

  def move(new_position)
    @pos = new_position
  end

  def destroy
    @pos = initial_pos
    @is_active = false
    @can_be_moved = false
  end

  def finish(finish_pos)
    @pos = finish_pos
    @is_active = false
    @is_finished = true
    @can_be_moved = false
  end

  def ==(other_pawn)
    if(@name == other_pawn.name && @player_name == other_pawn.player_name &&
        @initial_pos == other_pawn.initial_pos && @pos == other_pawn.pos &&
        @is_active == other_pawn.is_active && @is_finished == other_pawn.is_finished)
      true
    else
      false
    end
  end
end