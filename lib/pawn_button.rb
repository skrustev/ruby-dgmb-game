class PawnButton
  attr_accessor :x, :y

  def initialize(window, pawn, image, x, y, z, callback)
    @window = window
    @pawn = pawn
    @main_image = image
    @active_image = @main_image
    @callback = callback
    @x = x
    @y = y
    @z = z
    @x_offset = (@window.width / 4) + 32
    @y_offset = 32

  end

  def draw
    @active_image.draw(@x, @y, @z)
  end

  def update
    @x = @x_offset + (@pawn.pos[1] * @window.block_size)
    @y = @y_offset + (@pawn.pos[0] * @window.block_size)
  end

  def is_mouse_hovering
    mx = @window.mouse_x
    my = @window.mouse_y

    (mx >= @x && my >= @y) && (mx <= @x + @active_image.width) && (my <= @y + @active_image.height)
  end

  def clicked
    if is_mouse_hovering
      @callback.call @pawn.name
    end
  end
end