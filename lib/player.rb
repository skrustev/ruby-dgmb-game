require_relative 'pawn'

class Player
  attr_accessor :last_roll, :has_rolled
  attr_reader :name, :color, :initial_pos, :start_pos,
              :active_pawns, :finished_pawns,
              :pawns, :path

  def initialize(name = nil, color = nil)
    @name = name
    @color = color
    @initial_pos = []
    @start_pos = []
    @active_pawns = 0
    @finished_pawns = 0
    @last_roll = 0
    @has_rolled = false
    @pawns = {}
    @path = []

    determine_positions(@color)
    create_pawns
  end

  def determine_positions(color)

    if color == "red"        
      @initial_pos = [[2, 2], [2, 3], [3, 2], [3, 3]]
      @path = 
        [[8, 0], [8, 1], [8, 2], [8, 3], [8, 4], [8, 5], [9, 5], [9, 6], [10, 6], [11, 6], [12, 6], [13, 6], [14, 6], [14, 7],
         [14, 8], [13, 8], [12, 8], [11, 8], [10, 8], [9, 8], [9, 9], [8, 9], [8, 10], [8, 11], [8, 12], [8, 13], [8, 14], [7, 14],
         [6, 14], [6, 13], [6, 12], [6, 11], [6, 10], [6, 9], [5, 9], [5, 8], [4, 8], [3, 8], [2, 8], [1, 8], [0, 8], [0, 7],
         [0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [5, 5], [6, 5], [6, 4], [6, 3], [6, 2], [6, 1], [6, 0], [7, 0],
         [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6]]

    elsif color == "yellow"      
      @initial_pos = [[11, 2], [11, 3], [12, 2], [12, 3]]
      @path = 
        [[14, 8], [13, 8], [12, 8], [11, 8], [10, 8], [9, 8], [9, 9], [8, 9], [8, 10], [8, 11], [8, 12], [8, 13], [8, 14], [7, 14],
         [6, 14], [6, 13], [6, 12], [6, 11], [6, 10], [6, 9], [5, 9], [5, 8], [4, 8], [3, 8], [2, 8], [1, 8], [0, 8], [0, 7],
         [0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [5, 5], [6, 5], [6, 4], [6, 3], [6, 2], [6, 1], [6, 0], [7, 0],
         [8, 0], [8, 1], [8, 2], [8, 3], [8, 4], [8, 5], [9, 5], [9, 6], [10, 6], [11, 6], [12, 6], [13, 6], [14, 6], [14, 7],
         [13, 7], [12, 7], [11, 7], [10, 7], [9, 7], [8, 7]]

    elsif color == "green"
      @initial_pos = [[11, 11], [11, 12], [12, 11], [12, 12]]
      @path = 
        [[6, 14], [6, 13], [6, 12], [6, 11], [6, 10], [6, 9], [5, 9], [5, 8], [4, 8], [3, 8], [2, 8], [1, 8], [0, 8], [0, 7],
         [0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [5, 5], [6, 5], [6, 4], [6, 3], [6, 2], [6, 1], [6, 0], [7, 0],
         [8, 0], [8, 1], [8, 2], [8, 3], [8, 4], [8, 5], [9, 5], [9, 6], [10, 6], [11, 6], [12, 6], [13, 6], [14, 6], [14, 7],
         [14, 8], [13, 8], [12, 8], [11, 8], [10, 8], [9, 8], [9, 9], [8, 9], [8, 10], [8, 11], [8, 12], [8, 13], [8, 14], [7, 14],
         [7, 13], [7, 12], [7, 11], [7, 10], [7, 9], [7, 8]]

    elsif color == "blue"
     @initial_pos = [[2, 11], [2, 12], [3, 11], [3, 12]]
     @path =  
        [[0, 6], [1, 6], [2, 6], [3, 6], [4, 6], [5, 6], [5, 5], [6, 5], [6, 4], [6, 3], [6, 2], [6, 1], [6, 0], [7, 0],
         [8, 0], [8, 1], [8, 2], [8, 3], [8, 4], [8, 5], [9, 5], [9, 6], [10, 6], [11, 6], [12, 6], [13, 6], [14, 6], [14, 7],
         [14, 8], [13, 8], [12, 8], [11, 8], [10, 8], [9, 8], [9, 9], [8, 9], [8, 10], [8, 11], [8, 12], [8, 13], [8, 14], [7, 14],
         [6, 14], [6, 13], [6, 12], [6, 11], [6, 10], [6, 9], [5, 9], [5, 8], [4, 8], [3, 8], [2, 8], [1, 8], [0, 8], [0, 7],
         [1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7]]
    end

    @start_pos = @path[0]
  end

  def create_pawns
    [0,1,2,3].each do |index|
      @pawns[:"#{@color[0]}:#{index}"] = Pawn.new("#{@color[0]}:#{index}", @name, @initial_pos[index])
    end
  end
  
  def roll_dice
    @has_rolled = true
    roll = 1 + rand(6)
    @last_roll = roll
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

  def destroy_pawn(pawn_name)
    if(pawns[:"#{pawn_name}"].is_active)
      pawns[:"#{pawn_name}"].destroy
      @active_pawns -= 1
    end

    pawns[:"#{pawn_name}"].pos
  end

  def reset
    @active_pawns = 0
    @finished_pawns = 0
    @last_roll = 0

    pawns.each do |name, pawn|
      pawn.reset
    end
  end
end