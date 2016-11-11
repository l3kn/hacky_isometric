class Helper
  def self.line(x0, y0, x1, y1, canvas, color, z, z_buffer)
    steep = (y1 - y0).abs > (x1 - x0).abs

    if steep
      x0, y0 = {y0, x0}
      x1, y1 = {y1, x1}
    end

    if x0 > x1
      x0, x1 = {x1, x0}
      y0, y1 = {y1, y0}
    end

    delta_x = x1 - x0
    delta_y = (y1 - y0).abs

    error = (delta_x / 2).to_i

    ystep = y0 < y1 ? 1 : -1
    y = y0

    ((x0.to_i)..(x1.to_i)).each do |x|
      if steep
        if canvas.includes_pixel?(y, x) && z >= z_buffer[y, x]
          canvas[y, x] = color
          z_buffer[y, x] = z
        end
      else
        if canvas.includes_pixel?(y, x) && z >= z_buffer[x, y]
          canvas[x, y] = color
          z_buffer[x, y] = z
        end
      end

      error -= delta_y
      if error < 0.0
        y += ystep
        error += delta_x
      end
    end
  end

  def self.scanline_fill(x, y, canvas, border, new, z, z_buffer)
    stack = [] of Tuple(Int32, Int32)
    stack << {x, y} if canvas.includes_pixel?(x, y)

    until stack.empty?
      x, y = stack.pop
      pixel = canvas[x, y]
      if (pixel != border && pixel != new) || z_buffer[x, y] < z
        canvas[x, y] = new
        z_buffer[x, y] = z
        stack << {x-1, y} if canvas.includes_pixel?(x-1, y)
        stack << {x+1, y} if canvas.includes_pixel?(x+1, y)
        stack << {x, y-1} if canvas.includes_pixel?(x, y-1)
        stack << {x, y+1} if canvas.includes_pixel?(x, y+1)
      end
    end
  end

  def self.darken(color, factor = 0.9)
    RGBA.new(
      (color.r * factor).to_u16,
      (color.g * factor).to_u16,
      (color.b * factor).to_u16,
      color.a
    )
  end
end


