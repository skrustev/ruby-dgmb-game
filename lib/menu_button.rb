class MenuButton
    attr_reader :hidden
    def initialize (window, image, x, y, z, callback, hover_image = nil, hidden = false)
      @window = window
      @main_image = image
      @hover_image = hover_image
      @hidden_image = Gosu::Image.new(@window, "images/empty_default.png", false)
      @x = x
      @y = y
      @z = z
      @callback = callback
      @active_image = @main_image
      @hidden = hidden
    end

    def draw
      @active_image.draw(@x, @y, @z) unless @hidden
    end

    def update
      if @hidden
        @active_image = @hidden_image
      elsif is_mouse_hovering && !@hover_image.nil?
        @active_image = @hover_image
      else 
        @active_image = @main_image
      end
    end

    def is_mouse_hovering
      mx = @window.mouse_x
      my = @window.mouse_y

      (mx >= @x && my >= @y) && (mx <= @x + @active_image.width) && (my <= @y + @active_image.height)
    end

    def clicked
      if is_mouse_hovering
        @callback.call
      end
    end

    def hide
      @hidden = true
    end

    def unhide
      @hidden = false
    end
  end