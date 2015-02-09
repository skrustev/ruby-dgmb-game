require_relative "menu_button"

class Menu
  attr_reader :hidden
  def initialize(window, hidden = false)
    @window = window
    @buttons = []
    @hidden = hidden
  end

  def add_item(image, x, y, z, callback, hover_image = nil)
    button = MenuButton.new(@window, image, x, y, z, callback, hover_image)
    @buttons << button
    self
  end

  def draw
    @buttons.each do |button|
      button.draw
    end
  end

  def update
    @buttons.each do |button|
      button.update
    end
  end

  def clicked
    @buttons.each do |button|
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
    self.add_item(Gosu::Image.new(@window, "images/start.png", false),
                        @x, @y, 1, callback, Gosu::Image.new(@window, "images/start_hover.png", false))

  end

  def add_exit_button(callback = lambda { @window.close })
    self.add_item(Gosu::Image.new(@window, "images/exit.png", false),
                      @x + @widthOffset, @y + @heightOffset, 1, callback, 
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
    self.add_item(Gosu::Image.new(@window, "images/select_players_message.png", false), 
                @x-20, @y-200, 1, lambda { @window })
  end

  def add_begin_button(callback = lambda { @window })
    self.add_item(Gosu::Image.new(@window, "images/begin.png", false),
                        @x, @y + 335, 1, callback, Gosu::Image.new(@window, "images/begin_hover.png", false))
  end

  def add_back_button(callback = lambda { @window })
    self.add_item(Gosu::Image.new(@window, "images/back.png", false),
                        @x + 3, @y + 385, 1, callback, Gosu::Image.new(@window, "images/back_hover.png", false))
  end
end