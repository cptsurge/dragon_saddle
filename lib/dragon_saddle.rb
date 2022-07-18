module DragonSaddle
  CANVAS_W = 1280
  CANVAS_H = 720
  CANVAS_CENTER_X = CANVAS_W.half
  CANVAS_CENTER_Y = CANVAS_H.half
  CANVAS_CENTER_POINT = { x: CANVAS_CENTER_X, y: CANVAS_CENTER_Y }

  attr_accessor :args

  def tick_count
    args.state.tick_count
  end

  def first_tick?
    args.state.tick_count.zero?
  end

  def every(duration, &block)
    block.call if tick_count % duration == 0
  end

  def keyboard
    args.inputs.keyboard
  end

  def mouse
    args.inputs.mouse
  end

  def solids
    args.outputs.solids
  end

  def static_sprites
    args.outputs.static_sprites
  end

  def sprites
    args.outputs.sprites
  end

  def primitives
    args.outputs.primitives
  end

  def borders
    args.outputs.borders
  end

  def sounds
    args.outputs.sounds
  end

  def play_sound(filename)
    args.outputs.sounds << "sounds/#{filename}"
  end

  def fast_each array, method
    fn.each_send array, self, method
  end

  def static_background_color(r = 0, g = 0, b = 0)
    args.outputs.static_solids << { x: 0, y: 0, w: CANVAS_W, h: CANVAS_H, r: r, g: g, b: b }
  end

  def output_fps
    args.outputs.labels << { x: 10, y: 30, text: "#{args.gtk.current_framerate.round} FPS", r: 255, g: 255, b: 255 }
  end
end

class Numeric
  # small helper for readability, as a compliment to Numeric#seconds
  # 30.frames ==> 30
  def frame; self; end
  def frames; self; end
end
