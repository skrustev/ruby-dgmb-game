require 'gosu'
require_relative 'lib/menu.rb'

class GameWindow < Gosu::Window
  attr_accessor :start_menu, :setup_menu
  WIDTH = 1280
  HEIGHT = 960

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Don't Get Mad Bro"

    @start_menu = StartMenu.new(self)
    @setup_menu = SetupMenu.new(self, true)
    @background = Gosu::Image.new(self, "images/background.png", false)

    start_menu_add_buttons
    setup_menu_add_buttons
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
    @setup_menu.add_begin_button

    back_callback  = lambda do
                              self.setup_menu.hide
                              self.start_menu.unhide
                            end
    @setup_menu.add_back_button(back_callback)
  end

  def update
    unless @start_menu.hidden
      @start_menu.update
    else
      @setup_menu.update
    end
  end

  def draw
    @fx = WIDTH.to_f/ @background.width.to_f
    @fy = HEIGHT.to_f/ @background.height.to_f
    @background.draw(0, 0, 0, @fx, @fy)

    unless @start_menu.hidden
      @start_menu.draw
    else
      @setup_menu.draw
    end
  end

  def button_down(id)
    if id == Gosu::MsLeft
      unless @start_menu.hidden
        @start_menu.clicked
      else
        @setup_menu.clicked
      end
    end
  end

  def needs_cursor?
    true
  end
end

window = GameWindow.new
window.show