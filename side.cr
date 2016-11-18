require "stumpy_core"
require "./vector"
require "./side"

class Side
  @origin : Vector3
  @dimensions : Vector3
  @color : StumpyCore::RGBA

  def initialize(@origin, @dimensions, @color)
  end

  def draw(canvas, z_buffer)
    a = @origin
    if @dimensions.x == 0.0
      b = @origin + @dimensions * Vector3::X.yxy
      c = @origin + @dimensions * Vector3::X.yxx
      d = @origin + @dimensions * Vector3::X.yyx

      center = @origin + @dimensions * Vector3::X.yxx / 2.0
    elsif @dimensions.y == 0.0
      b = @origin + @dimensions * Vector3::X.xyy
      c = @origin + @dimensions * Vector3::X.xyx
      d = @origin + @dimensions * Vector3::X.yyx

      center = @origin + @dimensions * Vector3::X.xyx / 2.0
    else
      b = @origin + @dimensions * Vector3::X.xyy
      c = @origin + @dimensions * Vector3::X.xxy
      d = @origin + @dimensions * Vector3::X.yxy
      
      center = @origin + @dimensions * Vector3::X.xxy / 2.0
    end

    pcenter = Isometric.project(center)

    vertices = [a,b,c,d].map do |v|
      Isometric.project(v).xy
    end

    polygon = Polygon.new(
      vertices,
      pcenter.z.to_i,
      @color
    )

    polygon.draw(canvas, z_buffer)
  end
end
