require "stumpy_png"
include StumpyPNG

world = Canvas.new(128, 128)
tile = StumpyPNG.read("base.png")

def tint(canvas : Canvas, color : RGBA)
  r0 = color.r.to_f / UInt16::MAX
  g0 = color.g.to_f / UInt16::MAX
  b0 = color.b.to_f / UInt16::MAX
  new_canvas = Canvas.new(canvas.width, canvas.height)
  (0...canvas.width).each do |x|
    (0...canvas.height).each do |y|
      pixel = canvas[x, y]
      r1 = pixel.r.to_f / UInt16::MAX
      g1 = pixel.g.to_f / UInt16::MAX
      b1 = pixel.b.to_f / UInt16::MAX
      new_canvas[x, y] = RGBA.new(
        (r0 * r1 * UInt16::MAX).to_u16,
        (g0 * g1 * UInt16::MAX).to_u16,
        (b0 * b1 * UInt16::MAX).to_u16,
        pixel.a
      )
    end
  end

  new_canvas
end

5.times do |i|
  5.times do |j|
    x = 31 * i
    y = 22 * j

    x -= 16 if j.odd?

    new_color = RGBA.from_rgb_n({50*j, 50*i, 255}, 8)
    new_tile = tint(tile, new_color)
    world.paste(new_tile, x, y)
  end
end

StumpyPNG.write(world, "output.png")
