require_relative "menu_button"
require_relative "pawn_button"

class Menu
  attr_accessor :hidden, :buttons
  def initialize(window, hidden = false)
    @window = window
    @buttons = {}
    @hidden = hidden
  end

  def add_item(name, image, x, y, z, callback, hover_image = nil, hidden = false)
    new_button = MenuButton.new(@window, image, x, y, z, callback, hover_image, hidden)
    @buttons[:"#{name}"] = new_button
    self
  end

  def draw
    @buttons.each do |name, button|
      button.draw unless button.hidden
    end
  end

  def update
    @buttons.each do |name, button|
      button.update
    end
  end

  def clicked
    @buttons.each do |name, button|
      button.clicked
    end
  end

  def hide
    @hidden = true
  end

  def unhide
    @hidden = false
  end
end

class StartMenu < Menu
  def initialize(window, hidden = false)
    super(window, hidden)

    @x = (@window.width / 4)/2 - 50
    @y = @window.height  / 2 - 50
    @heightOffset = 75
    @widthOffset = 15
  end

  def add_start_button(callback = lambda { @window })
    self.add_item("start",
                  Gosu::Image.new(@window, "images/start.png", false),
                  @x,
                  @y,
                  1,
                  callback,
                  Gosu::Image.new(@window, "images/start_hover.png", false))
  end

  def add_exit_button(callback = lambda { @window.close })
    self.add_item("exit",
                  Gosu::Image.new(@window, "images/exit.png", false),
                  @x + @widthOffset,
                  @y + @heightOffset,
                  1,
                  callback,
                  Gosu::Image.new(@window, "images/exit_hover.png", false))
  end

end

class SetupMenu < Menu
  def initialize(window, hidden = false)
    super(window, hidden)

    @x = (@window.width / 4)/2 - 50
    @y = @window.height  / 2
    @heightOffset = 75
  end

  def add_selection_message
    self.add_item("select_players_message",
                  Gosu::Image.new(@window, "images/select_players_message.png", false),
                  @x-20,
                  @y-200,
                  1,
                  lambda { @window })
  end

  def add_begin_button(callback = lambda { @window })
    self.add_item("begin",
                  Gosu::Image.new(@window, "images/begin.png", false),
                  @x,
                  @y + 335,
                  1,
                  callback,
                  Gosu::Image.new(@window, "images/begin_hover.png", false),
                  )
  end

  def add_back_button(callback = lambda { @window })
    self.add_item("back",
                  Gosu::Image.new(@window, "images/back.png", false),
                  @x + 3,
                  @y + 385,
                  1,
                  callback,
                  Gosu::Image.new(@window, "images/back_hover.png", false))
  end

  def add_player_select_buttons
    select_category = ["blue", "red", "yellow", "green"]
    dummy_callback = lambda { @window }
    offset_y = -75

    select_category.each do |category|
      callback_player = lambda do
                                @buttons[:"#{category}_player"].hide
                                @buttons[:"#{category}_empty"].unhide
                              end

      callback_empty = lambda do
                                @buttons[:"#{category}_empty"].hide
                                @buttons[:"#{category}_player"].unhide
                              end

      self.add_item("#{category}_player",
                  Gosu::Image.new(@window, "images/#{category}_player.png", false),
                  @x - 10,
                  @y + offset_y,
                  1,
                  callback_player,
                  Gosu::Image.new(@window, "images/#{category}_player_hover.png", false))

      self.add_item("#{category}_empty",
                  Gosu::Image.new(@window, "images/#{category}_empty.png", false),
                  @x - 10,
                  @y + offset_y,
                  1,
                  callback_empty,
                  Gosu::Image.new(@window, "images/#{category}_empty_hover.png", false),
                  true)
      offset_y += 60
    end
  end

  def get_players_selected
    array_players = []
    select_category = ["blue", "red", "yellow", "green"]

    select_category.each do |category|
      unless @buttons[:"#{category}_player"].hidden
        array_players << category
      end
    end

    array_players
  end
end

class IngameMenu < Menu
  def initialize(window, hidden = false)
    super(window, hidden)

    @pawn_buttons = {}
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
  end

  def update
    @buttons.each do |name, button|
      button.update
    end

    @pawn_buttons.each do |name, pawn_button|
      pawn_button.update
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

  def add_pawn_buttons
    @window.game_mode.players.each do |player_name, player|
      player.pawns.each do |pawn_name, pawn|
        self.add_pawn(pawn_name,
                      pawn,
                      Gosu::Image.new(@window, "images/#{player.color}_pawn.png", false),
                      500,
                      500,
                      1)
      end
    end
  end

  def add_exit_button(callback = lambda { @window.close })
    self.add_item("exit",
                  Gosu::Image.new(@window, "images/exit.png", false),
                  @x + 3,
                  @y + 385,
                  1,
                  callback,
                  Gosu::Image.new(@window, "images/exit_hover.png", false))
  end
  
  protected

  def add_pawn(name, pawn_object, image, x, y, z)
    new_pawn = PawnButton.new(@window, pawn_object, image, x, y, z)
    @pawn_buttons[:"#{name}"] = new_pawn
  end
end