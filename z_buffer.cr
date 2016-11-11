class ZBuffer
  getter width : Int32
  getter height : Int32
  getter values : Slice(Int32)

  def initialize(@width, @height, initial = 0)
    @values = Slice.new(@width * @height, initial)
  end

  def set(x, y, color)
    @values[x + @width * y] = color
  end

  def get(x, y)
    @values[x + @width * y]
  end

  def []=(x, y, color)
    set(x, y, color)
  end

  def [](x, y)
    get(x, y)
  end

  def wrapping_get(x : Int32, y : Int32) : RGBA
    self[x % @width, y % @height]
  end

  def wrapping_set(x : Int32, y : Int32, color : RGBA)
    self[x % @width, y % @height] = color
  end

  def safe_get(x : Int32, y : Int32) : RGBA | Nil
    if x < 0 || x >= width
      nil
    elsif y < 0 || y >= height
      nil
    else
      self[x, y]
    end
  end

  def safe_set(x : Int32, y : Int32, color : RGBA) : Bool
    if x < 0 || x >= width
      false
    elsif y < 0 || y >= height
      false
    else
      self[x, y] = color
      true
    end
  end

  def includes_pixel?(x, y)
    0 <= x && x < @width && 0 <= y && y < @height
  end

  def each_column(&block)
    @height.times do |n|
      yield @values[n * @width, @width]
    end
  end

  def ==(other)
    self.class == other.class &&
      @width == other.width &&
      @height == other.height &&
      @values == other.values
  end
end
