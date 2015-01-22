class Pawn 
  attr_reader :name, :player_name, :pos, :original_pos, 
              :is_active, :is_finished, :can_be_moved

  def initialize(name = nil, player_name = nil, initial_pos = "0:0")
    @name = name;
    @player_name = player_name
    @original_pos = initial_pos
    @pos = @original_pos
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
    @pos = original_pos
    @is_active = false
    @can_be_moved = false
  end

  def finish(finish_pos)
    @pos = finish_pos
    @is_active = false
    @is_finished = true
    @can_be_moved = false
  end
end