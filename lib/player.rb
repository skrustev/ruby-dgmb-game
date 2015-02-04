require_relative 'pawn'

class Player
  attr_accessor :last_roll
  attr_reader :name, :color, :initial_pos, :start_pos,
              :active_pawns, :finished_pawns,
              :pawns

  def initialize(name = nil, color = nil)
    @name = name
    @color = color
    @initial_pos = []
    @start_pos = []
    @active_pawns = 0
    @finished_pawns = 0
    @last_roll = 0
    @pawns = {}
    @path = []

    determine_positions(@color)
    create_pawns
  end

  def determine_positions(color)

    if color == "blue"
     @initial_pos = [[0, 0], [0, 1], [1, 0], [1, 1]]
     @path =  [[0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [4, 3], [4, 2], [4, 1], [4, 0], [5, 0],
              [6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [7, 4], [8, 4], [9, 4], [10, 4], [10, 5],
              [10, 6], [9, 6], [8, 6], [7, 6], [6, 6], [6, 7], [6, 8], [6, 9], [6, 10], [5, 10],
              [4, 10], [4, 9], [4, 8], [4, 7], [4, 6], [3,6], [2, 6], [1, 6], [0, 6], [0, 5],
              [1, 5], [2, 5], [3, 5], [4, 5]]

    elsif color == "yellow"      
      @initial_pos = [[9, 0], [9, 1], [10, 0], [10, 1]]
      @path = [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [7, 4], [8, 4], [9, 4], [10, 4], [10, 5],
              [10, 6], [9, 6], [8, 6], [7, 6], [6, 6], [6, 7], [6, 8], [6, 9], [6, 10], [5, 10],
              [4, 10], [4, 9], [4, 8], [4, 7], [4, 6], [3, 6], [2, 6], [1, 6], [0, 6], [0, 5],
              [0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [4, 3], [4, 2], [4, 1], [4, 0], [5, 0],
              [5, 1], [5, 2], [5, 3], [5, 4]]

    elsif color == "green"
      @initial_pos = [[9, 9], [9, 10], [10, 9], [10, 10]]
      @path = [[10, 6], [9, 6], [8, 6], [7, 6], [6, 6], [6, 7], [6, 8], [6, 9], [6, 10], [5, 10],
              [4, 10], [4, 9], [4, 8], [4, 7], [4, 6], [3, 6], [2, 6], [1, 6], [0, 6], [0, 5],
              [0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [4, 3], [4, 2], [4, 1], [4, 0], [5, 0],
              [6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [7, 4], [8, 4], [9, 4], [10, 4], [10, 5],
              [9, 5], [8, 5], [7, 5], [6, 5]]

    elsif color == "red"        
      @initial_pos = [[0, 9], [0, 10], [1, 9], [1, 10]]
      @path = [[4, 10], [4, 9], [4, 8], [4, 7], [4, 6], [3,6], [2, 6], [1, 6], [0, 6], [0, 5],
              [0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [4, 3], [4, 2], [4, 1], [4, 0], [5, 0],
              [6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [7, 4], [8, 4], [9, 4], [10, 4], [10, 5],
              [10, 6], [9, 6], [8, 6], [7, 6], [6, 6], [6, 7], [6, 8], [6, 9], [6, 10], [5, 10],
              [5, 9], [5, 8], [5, 7], [5, 6]]
    end

    @start_pos = @path[0]
  end

  def create_pawns
    [0,1,2,3].each do |index|
      @pawns[:"#{@color[0]}:#{index}"] = Pawn.new("#{@color[0]}:#{index}", @name, @initial_pos[index])
    end
  end
  
  def roll_dice
    @last_roll = 1 + rand(6)
  end

  def activate_pawn(pawn_name)
    pawns[:"#{pawn_name}"].activate(start_pos)
    @active_pawns += 1
  end

  def move_pawn(pawn_name, move_positions)
    position_on_path = pawns[:"#{pawn_name}"].path_pos
    pawns[:"#{pawn_name}"].move(move_positions, @path[position_on_path + move_positions])
  end

  def finish_pawn(pawn_name)
    pawns[:"#{pawn_name}"].finish
    @active_pawns -= 1
    @finished_pawns += 1
  end
end