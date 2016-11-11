require "stumpy_png"
include StumpyPNG

require "./isometric"
require "./helper"
require "./z_buffer"

class Block
  @origin : Tuple(Int32, Int32, Int32)
  @dimensions : Tuple(Int32, Int32, Int32)
  @color : RGBA

  @sides : Array(Side)

  def initialize(@origin, @dimensions, @color)
    a = Side.new(
      {@origin[0], @origin[1], @origin[2]},
      {0, @dimensions[1], @dimensions[2]},
      Helper.darken(@color)
    )
    b = Side.new(
      {@origin[0], @origin[1], @origin[2]},
      {@dimensions[0], 0, @dimensions[2]},
      @color
    )
    c = Side.new(
      {@origin[0], @origin[1], @origin[2]},
      {@dimensions[0], @dimensions[1], 0},
      Helper.darken(@color, 0.6)
    )
    d = Side.new(
      {@origin[0] + @dimensions[0], @origin[1], @origin[2]},
      {0, @dimensions[1], @dimensions[2]},
      Helper.darken(@color)
    )
    e = Side.new(
      {@origin[0], @origin[1] + @dimensions[1], @origin[2]},
      {@dimensions[0], 0, @dimensions[2]},
      @color
    )
    f = Side.new(
      {@origin[0], @origin[1], @origin[2] + @dimensions[2]},
      {@dimensions[0], @dimensions[1], 0},
      Helper.darken(@color, 0.6)
    )
    @sides = [a, b, c, d, e, f]
  end

  def draw(canvas, z_buffer)
    @sides.each do |side|
      side.draw(canvas, z_buffer)
    end
  end
end

class Side
  @origin : Tuple(Int32, Int32, Int32)
  @dimensions : Tuple(Int32, Int32, Int32)
  @color : RGBA

  def initialize(@origin, @dimensions, @color)
  end

  def draw(canvas, z_buffer)
    if @dimensions[0] == 0
      dim_y = @dimensions[1]
      dim_z = @dimensions[2]
      a = {@origin[0], @origin[1], @origin[2]}
      b = {@origin[0], @origin[1] + dim_y, @origin[2]}
      c = {@origin[0], @origin[1] + dim_y, @origin[2] + dim_z}
      d = {@origin[0], @origin[1], @origin[2] + dim_z}

      center = {@origin[0], @origin[1] + dim_y / 2, @origin[2] + dim_z / 2}
    elsif @dimensions[1] == 0
      dim_x = @dimensions[0]
      dim_z = @dimensions[2]
      a = {@origin[0], @origin[1], @origin[2]}
      b = {@origin[0] + dim_x, @origin[1], @origin[2]}
      c = {@origin[0] + dim_x, @origin[1], @origin[2] + dim_z}
      d = {@origin[0], @origin[1], @origin[2] + dim_z}

      center = {@origin[0] + dim_x / 2, @origin[1], @origin[2] + dim_z / 2}
    else
      dim_x = @dimensions[0]
      dim_y = @dimensions[1]
      a = {@origin[0], @origin[1], @origin[2]}
      b = {@origin[0] + dim_x, @origin[1], @origin[2]}
      c = {@origin[0] + dim_x, @origin[1] + dim_y, @origin[2]}
      d = {@origin[0], @origin[1] + dim_y, @origin[2]}
      
      center = {@origin[0] + dim_x / 2, @origin[1] + dim_y / 2, @origin[2]}
    end

    x, y, z = Isometric.project(center)

    border = RGBA.from_rgb_n({100, 100, 100}, 8)
    Isometric.line(a, b, canvas, border, z, z_buffer)
    Isometric.line(b, c, canvas, border, z, z_buffer)
    Isometric.line(c, d, canvas, border, z, z_buffer)
    Isometric.line(d, a, canvas, border, z, z_buffer)

    Helper.scanline_fill(
      x, y, canvas,
      border,
      @color,
      z,
      z_buffer
    )
  end
end

width, height = {500, 500}

world = Canvas.new(width, height, RGBA.from_rgb_n({255, 255, 255}, 8))
z_buffer = ZBuffer.new(width, height, -999999)

blocks = [] of Block

size = 20

100.times do |i|
  100.times do |j|
    y = 5 * Math.sin(i.to_f / 5) - 5
    blocks << Block.new(
      {i * size, y.to_i32 * size, j * size},
      {size, size, size},
      RGBA.from_rgb_n({255 * Math.sin(i.to_f / 20), 255 * Math.cos(j.to_f / 20), 0}, 8)
    )
  end
end

blocks.each do |block|
  block.draw(world, z_buffer)
end

StumpyPNG.write(world, "output.png")
