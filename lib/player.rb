class Player
  attr_reader :name, :color, :initial_pos, :start_pos,
              :active_pawns, :finished_pawns, :last_roll

  def initialize(name = nil, color = nil)
    @name = name
    @color = color
    @active_pawns = 0
    @finished_pawns = 0
    @last_roll = [0, 0]

    determine_positions(@color)
  end

  def determine_positions(color)
    case color
    when "black"  then @start_pos, @initial_pos = [0, 5],
                        [[0,0], [0,1], [1,0], [1,1]]                 
    when "yellow" then @start_pos, @initial_pos = [7, 0],
                        [[10,0], [10,1], [11,0], [11,1]]
    when "green"  then @start_pos, @initial_pos = [11, 7],
                        [[11,10], [10,10], [11,11], [10, 11]]
    when "red"    then @start_pos, @initial_pos = [5, 11],
                        [[1,11], [1, 10], [0,10], [0,11]]
    end
  end

  def roll_dice
    1 + rand(6)
  end
end