require "stumpy_core"
require "./vector"
require "./side"

class Block
  @origin : Vector3
  @dimensions : Vector3
  @color : StumpyCore::RGBA

  @sides : Array(Side)

  def initialize(@origin, @dimensions, @color)
    a = Side.new(
      @origin,
      @dimensions * Vector3::X.yxx,
      Helper.darken(@color)
    )
    b = Side.new(
      @origin,
      @dimensions * Vector3::X.xyx,
      @color
    )
    c = Side.new(
      @origin,
      @dimensions * Vector3::X.xxy,
      Helper.darken(@color, 0.6)
    )
    d = Side.new(
      @origin + @dimensions * Vector3::X,
      @dimensions * Vector3::X.yxx,
      Helper.darken(@color)
    )
    e = Side.new(
      @origin + @dimensions * Vector3::Y,
      @dimensions * Vector3::X.xyx,
      @color
    )
    f = Side.new(
      @origin + @dimensions * Vector3::Z,
      @dimensions * Vector3::X.xxy,
      Helper.darken(@color, 0.6)
    )
    @sides = [a, b, c, d, e, f]
  end

  def draw(canvas, z_buffer)
    @sides.each(&.draw(canvas, z_buffer))
  end
end
