require_relative 'pawn'

class Player
  attr_reader :name, :color, :initial_pos, :start_pos,
              :active_pawns, :finished_pawns, :last_roll,
              :pawns

  def initialize(name = nil, color = nil)
    @name = name
    @color = color
    @initial_pos = []
    @start_pos = []
    @active_pawns = 0
    @finished_pawns = 0
    @last_roll = [0, 0]
    @pawns = {}

    determine_positions(@color)
    create_pawns
  end

  def determine_positions(color)
    case color
    when "blue"  then @start_pos, @initial_pos = [0, 4],  [[0,0], [0,1], [1,0], [1,1]]                 
    when "yellow" then @start_pos, @initial_pos = [6, 0],  [[9,0], [9,1], [10,0], [10,1]]
    when "green"  then @start_pos, @initial_pos = [10, 6], [[9,9], [9,10], [10,9], [10, 10]]
    when "red"    then @start_pos, @initial_pos = [4, 10], [[0,9], [0, 10], [1,9], [1,10]]
    end
  end

  def create_pawns
    [0,1,2,3].each do |index|
      @pawns[:"#{@color[0]}:#{index}"] = Pawn.new("#{@color[0]}:#{index}", @name, @initial_pos[index])
    end
  end
  
  def roll_dice
    1 + rand(6)
  end
end