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

  def inside(xx, yy)
    w = @width
    h = @height
    if (w | h) < 0
      return false
    end
    x = @x
    y = @y
    if xx < x || yy < y
      return false
    end
    w += x
    h += y
    ((w < x || w > xx) &&
      (h < y || h > yy))
  end


  def contains(point)
    inside(point.x, point.y)
  end


  def intersects(rectangle)
    tw = @width
    th = @height
    rw = rectangle.width
    rh = rectangle.height
    if rw <= 0 || rh <= 0 || tw <= 0 || th <= 0
      return false
    end
    tx = @x
    ty = @y
    rx = rectangle.x
    ry = rectangle.y
    rw += rx
    rh += ry
    tw += tx
    th += ty
    ((rw < rx || rw > tx) &&
      (rh < ry || rh > ty) &&
      (tw < tx || tw > rx) &&
      (th < ty || th > ry))
  end


  def contains_raisin?(point)
    return false if @raisin.nil?

    raisin_x = @raisin.x
    raisin_y = @raisin.y

    raisin_x >= @x && raisin_x < @x + @width && raisin_y >= @y && raisin_y < @y + @height
  end

end