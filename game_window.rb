require 'gosu'
require_relative 'lib/menu.rb'

class GameWindow < Gosu::Window
  attr_accessor :start_menu, :setup_menu
  WIDTH = 1280
  HEIGHT = 960

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Don't Get Mad Bro"

    @start_menu = Menu.new(self)
    @setup_menu = Menu.new(self, true)
    @background = Gosu::Image.new(self, "images/background.png", false)
    
    initialize_start_menu
    initialize_setup_menu
  end

  def initialize_start_menu
    x = (self.width / 4)/2 - 50
    y = self.height  / 2 - 50
    heightOffset = 75
    widthOffset = 15


    buttons = ["start", "exit"]
    start_callback =  lambda do
                        self.start_menu.hide
                        self.setup_menu.unhide
                      end
    exit_callback = lambda { self.close }

    button_callbacks = [start_callback]
    button_callbacks << exit_callback

    button_callbacks.each_with_index do |callback, index|
      @start_menu.add_item(Gosu::Image.new(self, "images/#{buttons[index]}.png", false),
                        x, y, 1, callback, Gosu::Image.new(self, "images/#{buttons[index]}_hover.png", false))
      x += widthOffset
      y += heightOffset
    end
  end

  def initialize_setup_menu
    x = (self.width / 4)/2 - 50
    y = self.height  / 2
    heightOffset = 200

    buttons = ["begin", "back"]
    begin_callback = lambda { self }
    back_callback  = lambda do
                              self.setup_menu.hide
                              self.start_menu.unhide
                            end

    @setup_menu.add_item(Gosu::Image.new(self, "images/select_players_message.png", false), x-20, y-200, 1, lambda { self })
    

    @setup_menu.add_item(Gosu::Image.new(self, "images/begin.png", false),
                        x, y + 300, 1, begin_callback, Gosu::Image.new(self, "images/begin_hover.png", false))
    @setup_menu.add_item(Gosu::Image.new(self, "images/back.png", false),
                        x, y + 375, 1, back_callback, Gosu::Image.new(self, "images/back_hover.png", false))

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