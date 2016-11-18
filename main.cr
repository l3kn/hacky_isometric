require "stumpy_png"

require "./isometric"
require "./helper"
require "./z_buffer"
require "./slpf"
require "./vector"
require "./block"

include StumpyPNG

width, height = {500, 500}
world = Canvas.new(width, height, RGBA.from_rgb_n({255, 255, 255}, 8))
z_buffer = ZBuffer.new(width, height, -999999)

blocks = [] of Block

size = 20.0

100.times do |i|
  100.times do |j|
    y = 5 * Math.sin(i.to_f / 5) - 5
    blocks << Block.new(
      Vector3.new(i * size, y.round * size, j * size), 
      Vector3.new(size),
      RGBA.from_rgb_n({255 * Math.sin(i.to_f / 20), 255 * Math.cos(j.to_f / 20), 0}, 8)
    )
  end
end

blocks.each do |block|
  block.draw(world, z_buffer)
end

StumpyPNG.write(world, "output.png")
