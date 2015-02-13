require 'gosu'
require_relative 'lib/game_mode.rb'
require_relative 'lib/menu.rb'
require_relative 'lib/ingame_ui.rb'

class GameWindow < Gosu::Window
  attr_accessor :game_mode, :start_menu, :setup_menu,
                :ingame_ui, :block_size
  WIDTH = 1280
  HEIGHT = 960

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Don't Get Mad Bro"
    @background = Gosu::Image.new(self, "images/background.png", false)

    @start_menu = StartMenu.new(self)
    @setup_menu = SetupMenu.new(self, true)
    @ingame_ui = IngameUi.new(self, true)
    
    @game_mode = GameMode.new
    @players_already_added = false
    @block_size = 60

    start_menu_add_buttons
    setup_menu_add_buttons
    ingame_ui_add_buttons
  end

  def update
    if !@start_menu.hidden
      @start_menu.update
    elsif !@setup_menu.hidden
      @setup_menu.update
    elsif !@ingame_ui.hidden
      @ingame_ui.update  
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
    elsif !@ingame_ui.hidden
      @ingame_ui.draw  
    end
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if !@start_menu.hidden
        @start_menu.clicked
      elsif !@setup_menu.hidden
        @setup_menu.clicked
      elsif !@ingame_ui.hidden
        @ingame_ui.clicked        
      end
    end
  end

  def needs_cursor?
    true
  end

  def start_menu_add_buttons
    start_callback =  lambda do
                        self.start_menu.hide
                        self.setup_menu.unhide
                      end
    @start_menu.add_start_button(start_callback)
    @start_menu.add_exit_button
  end

  def setup_menu_add_buttons
    @setup_menu.add_selection_message
    @setup_menu.add_player_select_buttons

    pawns_callback =  lambda do |pawn_name|
                        player = @game_mode.players[:"#{@game_mode.turn}"]
                        result = @game_mode.select_pawn(pawn_name)
                        puts player.name + " last roll = " + player.last_roll.to_s
                        unless result.is_a?(String)
                          if(result.is_active)
                            @game_mode.move_selected_pawn
                          else
                            @game_mode.activate_selected_pawn
                          end
                        end
                      end

    begin_callback =  lambda do 
                        self.game_mode_add_players
                        self.setup_menu.hide
                        self.ingame_ui.unhide
                        self.ingame_ui.add_pawn_buttons(pawns_callback)

                        #if first is AI, make sure to activate it
                        if @game_mode.players[:"#{@game_mode.turn}"].is_a?(AI)
                          @game_mode.ai_action
                        end
                      end
    @setup_menu.add_begin_button(begin_callback)

    back_callback = lambda do
                      self.setup_menu.hide
                      self.start_menu.unhide
                      self.clear_game
                    end
    @setup_menu.add_back_button(back_callback)
  end

  def ingame_ui_add_buttons
    roll_callback = lambda do
                      player = @game_mode.players[:"#{@game_mode.turn}"]
                      if @game_mode.can_roll
                        rolled = player.roll_dice
                        @game_mode.can_roll = false

                        puts "Player " + @game_mode.turn + " rolled " + rolled.to_s

                        if(rolled != 6 && player.active_pawns == 0 )
                          @game_mode.next_turn
                        elsif rolled != 6
                          player.pawns.each do |name, pawn|
                            return unless @game_mode.select_pawn(name).is_a?(String)
                          end

                          @game_mode.next_turn                                              
                        end
                      end
                    end
    @ingame_ui.add_roll_button(roll_callback)

    back_callback = lambda do
                      self.ingame_ui.hide
                      self.start_menu.unhide
                      self.clear_game
                    end
    @ingame_ui.add_exit_button(back_callback)

    @ingame_ui.add_turn_info
    @ingame_ui.add_roll_info
    @ingame_ui.add_win_info
  end

  def game_mode_add_players
    if @players_already_added
      puts "Players already added"
      return
    end

    selected = @setup_menu.get_players_ai_selected

    selected.each do |player_color, type|
      if type == "player"
        player =  case player_color
                  when "blue"   then Player.new("player1", "blue")
                  when "red"    then Player.new("player2", "red")
                  when "yellow" then Player.new("player3", "yellow")
                  when "green"  then Player.new("player4", "green")
                  end

        @game_mode.add_player(player)
      elsif type == "ai"
        ai =  case player_color
                  when "blue"   then AI.new(@game_mode, "player1", "blue")
                  when "red"    then AI.new(@game_mode, "player2", "red")
                  when "yellow" then AI.new(@game_mode, "player3", "yellow")
                  when "green"  then AI.new(@game_mode, "player4", "green")
                  end

        @game_mode.add_player(ai)
      end
    end

      @players_already_added = true
  end

  def clear_game
    @players_already_added = false
    @game_mode.restart_game
    @game_mode.clear_game
  end
end

game = GameWindow.new
game.show