class Isometric
  def self.project(point : Tuple(Int32, Int32, Int32))
    a_x, a_y, a_z = point

    inv_sqrt6 = 1.0 / Math.sqrt(6)
    sqrt3 = Math.sqrt(3)
    sqrt2 = Math.sqrt(2)

    x = inv_sqrt6 * (sqrt3 * a_x - sqrt3 * a_z)
    y = inv_sqrt6 * (a_x + 2*a_y + a_z)
    z = inv_sqrt6 * (a_x * sqrt2 - a_y * sqrt2 + a_z * sqrt2)

    {x.round.to_i32, y.round.to_i32, z.round.to_i32}
  end

  def self.line(from, to, canvas, color, z, z_buffer)
    x0, y0, _z = self.project(from)
    x1, y1, _z = self.project(to)

    Helper.line(x0, y0, x1, y1, canvas, color, z, z_buffer)
  end
end
