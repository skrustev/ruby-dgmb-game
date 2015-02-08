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