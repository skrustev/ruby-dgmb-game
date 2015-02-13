require_relative './menu'

class IngameUi < Menu
  def initialize(window, hidden = false)
    super(window, hidden)

    @pawn_buttons = {}
    @turn_info = {}
    @roll_numbers = []
    @win_info = {}
    @ai_turn = false

    @x = (@window.width / 4)/2 - 50
    @y = @window.height  / 2
    @heightOffset = 75
  end

  def draw
    @buttons.each do |name, button|
      button.draw
    end

    @pawn_buttons.each do |name, pawn_button|
      pawn_button.draw
    end

    @roll_numbers.each do |number|
      number.draw
    end

    turn =  case @window.game_mode.turn
            when "player1" then "blue"
            when "player2" then "red"
            when "player3" then "yellow"
            when "player4" then "green"
            end
    @turn_info[:"#{turn}_turn"].draw

    if @window.game_mode.have_winner[0]
      winner = @window.game_mode.have_winner[1]
      @win_info[:"#{winner}_win"].draw
    else
      turn = @window.game_mode.turn
      player = @window.game_mode.players[:"#{turn}"]

      if player.last_roll > 0
        @roll_numbers[player.last_roll - 1].draw
      end
    end
  end

  def update
    @buttons.each do |name, button|
      button.update
    end

    @pawn_buttons.each do |name, pawn_button|
      pawn_button.update
    end

    turn = @window.game_mode.turn
    player = @window.game_mode.players[:"#{turn}"]

    if @window.game_mode.have_winner[0]
      @buttons[:"ai_turn"].hide
      @buttons[:"you_rolled_info"].hide
      @buttons[:"please_roll_info"].hide

      @roll_numbers.each do |roll_number|
        roll_number.hide
      end
    elsif player.is_a?(Player) 
      if player.last_roll == 0
        @buttons[:"ai_turn"].hide
        @buttons[:"you_rolled_info"].hide
        @buttons[:"please_roll_info"].unhide
      else
        @buttons[:"ai_turn"].hide
        @buttons[:"please_roll_info"].hide
        @buttons[:"you_rolled_info"].unhide
      end

      @roll_numbers.each_with_index do |roll_number, index|
        if player.last_roll == index + 1
          roll_number.unhide
        else
          roll_number.hide
        end
      end
    elsif player.is_a?(AI)
      @buttons[:"ai_turn"].unhide
      @buttons[:"please_roll_info"].hide
      @buttons[:"you_rolled_info"].hide
      @ai_turn = true
    end
  end

  def clicked
    @buttons.each do |name, button|
      button.clicked
    end

    @pawn_buttons.each do |name, pawn_button|
      pawn_button.clicked
    end
  end

  def hide
    @hidden = true
    @pawn_buttons = {}
  end

  def unhide
    @hidden = false
  end

  def add_turn_info
    dummy_callback = lambda { @window }
    self.add_item("player_turn_info",
                  Gosu::Image.new(@window, "images/player_turn_info.png", false),
                  100,
                  200,
                  1,
                  dummy_callback)

    colors = ["red", "blue", "green", "yellow"]
    offset_x = 20

    colors.each do |color|
      new_turn_info = MenuButton.new(@window,
                                      Gosu::Image.new(@window, "images/#{color}_turn.png", false),
                                      @x + offset_x,
                                      300,
                                      1,
                                      dummy_callback)

      @turn_info[:"#{color}_turn"] = new_turn_info
      offset_x -= 10
    end
  end

  def add_roll_info
    dummy_callback = lambda { @window }
    self.add_item("please_roll_info",
                  Gosu::Image.new(@window, "images/please_roll_info.png", false),
                  @x - 55,
                  @y - 70,
                  1,
                  dummy_callback)
    @buttons[:"please_roll_info"].hide

    self.add_item("you_rolled_info",
                  Gosu::Image.new(@window, "images/you_rolled_info.png", false),
                  @x - 50,
                  @y - 75,
                  1,
                  dummy_callback)
    @buttons[:"you_rolled_info"].hide

    self.add_item("ai_turn",
                  Gosu::Image.new(@window, "images/ai_turn.png", false),
                  @x - 55,
                  @y - 70,
                  1,
                  dummy_callback)
    @buttons[:"ai_turn"].hide

    numbers = [1, 2, 3, 4, 5, 6]
    numbers.each do |number|
      puts "Added roll image for " + number.to_s
      @roll_numbers << MenuButton.new(@window,
                                      Gosu::Image.new(@window, "images/#{number}.png", false),
                                      @x + 50,
                                      @y,
                                      1,
                                      dummy_callback)
      @roll_numbers[number - 1].hide
    end
  end

  def add_win_info
    dummy_callback = lambda { @window }
    colors = ["red", "blue", "green", "yellow"]
    offset_x = 0

    colors.each do |color|
      new_win_info = MenuButton.new(@window,
                                      Gosu::Image.new(@window, "images/#{color}_win.png", false),
                                      @x + offset_x,
                                      @y - 75,
                                      1,
                                      dummy_callback)

      @win_info[:"#{color}_win"] = new_win_info
      offset_x -= 10
    end
  end

  def add_pawn_buttons(callback = lambda { @window })
    @window.game_mode.players.each do |player_name, player|
      player.pawns.each do |pawn_name, pawn|
        self.add_pawn(pawn_name,
                      pawn,
                      Gosu::Image.new(@window, "images/#{player.color}_pawn.png", false),
                      500,
                      500,
                      1,
                      callback)
      end
    end
  end

  def add_roll_button(callback = lambda { @window })
    self.add_item("roll",
                  Gosu::Image.new(@window, "images/roll.png", false),
                  @x + 15,
                  @y + 325,
                  1,
                  callback,
                  Gosu::Image.new(@window, "images/roll_hover.png", false))
  end

  def add_exit_button(callback = lambda { @window.close })
    self.add_item("exit",
                  Gosu::Image.new(@window, "images/exit.png", false),
                  @x + 15,
                  @y + 385,
                  1,
                  callback,
                  Gosu::Image.new(@window, "images/exit_hover.png", false))
  end

  protected

  def add_pawn(name, pawn_object, image, x, y, z, callback)
    new_pawn = PawnButton.new(@window, pawn_object, image, x, y, z, callback)
    @pawn_buttons[:"#{name}"] = new_pawn
  end
end