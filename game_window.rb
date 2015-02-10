require 'gosu'
require_relative 'lib/game_mode.rb'
require_relative 'lib/menu.rb'

class GameWindow < Gosu::Window
  attr_accessor :game_mode, :start_menu, :setup_menu,
                :ingame_menu, :block_size
  WIDTH = 1280
  HEIGHT = 960

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Don't Get Mad Bro"
    @background = Gosu::Image.new(self, "images/background.png", false)

    @start_menu = StartMenu.new(self)
    @setup_menu = SetupMenu.new(self, true)
    @ingame_menu = IngameMenu.new(self, true)
    
    @game_mode = GameMode.new
    @players_already_added = false
    @block_size = 60

    start_menu_add_buttons
    setup_menu_add_buttons
    ingame_menu_add_buttons
  end

  def update
    if !@start_menu.hidden
      @start_menu.update
    elsif !@setup_menu.hidden
      @setup_menu.update
    elsif !@ingame_menu.hidden
      @ingame_menu.update  
    end
  end

  def draw
    @fx = WIDTH.to_f/ @background.width.to_f
    @fy = HEIGHT.to_f/ @background.height.to_f
    @background.draw(0, 0, 0, @fx, @fy)

    if !@start_menu.hidden
      @start_menu.draw
    elsif !@setup_menu.hidden
      @setup_menu.draw
    elsif !@ingame_menu.hidden
      @ingame_menu.draw  
    end
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if !@start_menu.hidden
        @start_menu.clicked
      elsif !@setup_menu.hidden
        @setup_menu.clicked
      elsif !@ingame_menu.hidden
        @ingame_menu.clicked        
      end
    end
  end

  def needs_cursor?
    true
  end

  def start_menu_add_buttons
    start_callback = lambda do
                              self.start_menu.hide
                              self.setup_menu.unhide
                            end
    @start_menu.add_start_button(start_callback)
    @start_menu.add_exit_button
  end

  def setup_menu_add_buttons
    @setup_menu.add_selection_message
    @setup_menu.add_player_select_buttons

    begin_callback = lambda do 
                              self.game_mode_add_players
                              self.setup_menu.hide
                              self.ingame_menu.unhide
                              self.ingame_menu.add_pawn_buttons
                            end
    @setup_menu.add_begin_button(begin_callback)

    back_callback  = lambda do
                              self.setup_menu.hide
                              self.start_menu.unhide
                              self.clear_game
                            end
    @setup_menu.add_back_button(back_callback)
    
  end

  def ingame_menu_add_buttons
    back_callback  = lambda do
                              self.ingame_menu.hide
                              self.start_menu.unhide
                              self.clear_game
                            end

    @ingame_menu.add_exit_button(back_callback)
  end

  def game_mode_add_players
    if @players_already_added
      puts "Players already added"
      return
    end

    players_selected = @setup_menu.get_players_selected

    players_selected.each do |player_color|
      player =  case player_color
                when "blue"   then Player.new("player1", "blue")
                when "red"    then Player.new("player2", "red")
                when "yellow" then Player.new("player3", "yellow")
                when "green"  then Player.new("player4", "green")
                end
      @game_mode.add_player(player)
      @players_already_added = true
    end
  end

  def clear_game
    @players_already_added = false
    @game_mode.clear_game
  end
end

game = GameWindow.new
game.show