class MenuButton
    def initialize (window, image, x, y, z, callback, hover_image = nil)
      @window = window
      @main_image = image
      @hover_image = hover_image
      @x = x
      @y = y
      @z = z
      @callback = callback
      @active_image = @main_image
    end

    def draw
      @active_image.draw(@x, @y, @z)
    end

    def update
      if is_mouse_hovering && !@hover_image.nil?
        @active_image = @hover_image
      else 
        @active_image = @main_image
      end
    end

    def is_mouse_hovering
      mx = @window.mouse_x
      my = @window.mouse_y

      (mx >= @x and my >= @y) and (mx <= @x + @active_image.width) and (my <= @y + @active_image.height)
    end

    def clicked
      if is_mouse_hovering then
        @callback.call
      end
    end
  end