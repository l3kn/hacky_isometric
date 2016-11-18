class Isometric
  def self.project(point : Vector3)
    a_x = point.x
    a_y = point.y
    a_z = point.z

    inv_sqrt6 = 1.0 / Math.sqrt(6)
    sqrt3 = Math.sqrt(3)
    sqrt2 = Math.sqrt(2)

    x = inv_sqrt6 * (sqrt3 * a_x - sqrt3 * a_z)
    y = inv_sqrt6 * (a_x + 2*a_y + a_z)
    z = inv_sqrt6 * (a_x * sqrt2 - a_y * sqrt2 + a_z * sqrt2)

    Vector3.new(x, y, z)
  end
end
