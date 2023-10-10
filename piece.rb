class Piece
  attr_accessor :x, :y, :width, :height, :raisin

  def initialize(x, y, width, height)
    @x = x
    @y = y
    @width= width
    @height = height
  end
  

  def locate_raisin(raisin)
    @raisin = raisin
  end

    def inside(x_check, y_check)
    width = @width
    height = @height

    if (width | height) < 0
      return false
    end

    x = @x
    y = @y

    if x_check < x || y_check < y
      return false
    end

    width += x
    height += y

    ((width < x || width > x_check) &&
    (height < y || height > y_check))
  end


  def contains(point)
    inside(point.x, point.y)
  end


    def intersects(rectangle)
    self_width = @width
    self_height = @height
    other_width = rectangle.width
    other_height = rectangle.height

    if other_width <= 0 || other_height <= 0 || self_width <= 0 || self_height <= 0
      return false
    end

    self_x = @x
    self_y = @y
    other_x = rectangle.x
    other_y = rectangle.y

    other_xw = other_x + other_width
    other_yh = other_y + other_height
    self_xw = self_x + self_width
    self_yh = self_y + self_height

    ((other_xw < other_x || other_xw > self_x) &&
    (other_yh < other_y || other_yh > self_y) &&
    (self_xw < self_x || self_xw > other_x) &&
    (self_yh < self_y || self_yh > other_y))
  end


  def contains_raisin?(point)
    return false if @raisin.nil?

    raisin_x = @raisin.x
    raisin_y = @raisin.y

    raisin_x >= @x && raisin_x < @x + @width && raisin_y >= @y && raisin_y < @y + @height
  end

end