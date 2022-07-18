class Game
  include DragonSaddle

  attr_reader :player, :bullets, :enemies

  def initialize(args)
    @args = args
    @player = { x: CANVAS_CENTER_X, y: CANVAS_CENTER_Y, w: 50, h: 50, r: 255, g: 0, b: 0, direction: :up }
    @bullets = []
    @enemies = []
  end

  def tick
    move_player
    move_enemies
    move_bullets
    shoot_bullets

    every 2.seconds do
      spawn_enemy
    end

    check_for_collisions
    render_everything
  end

  def move_player
    if keyboard.key_held.up
      player[:y] += 10
      player[:direction] = :up
    end

    if keyboard.key_held.down
      player[:y] -= 10
      player[:direction] = :down
    end

    if keyboard.key_held.left
      player[:x] -= 10
      player[:direction] = :left
    end

    if keyboard.key_held.right
      player[:x] += 10
      player[:direction] = :right
    end
  end

  def move_enemies
    enemies.each do |enemy|
      enemy.x += 2 if enemy.x < player[:x]
      enemy.x -= 2 if enemy.x > player[:x]
      enemy.y += 2 if enemy.y < player[:y]
      enemy.y -= 2 if enemy.y > player[:y]

      enemy.x += rand(3).randomize(:sign)
      enemy.y += rand(3).randomize(:sign)
    end
  end

  def move_bullets
    bullets.each do |bullet|
      case bullet[:direction]
      when :up then bullet[:y] += 15
      when :down then bullet[:y] -= 15
      when :left then bullet[:x] -= 15
      when :right then bullet[:x] += 15
      end
    end
  end

  def shoot_bullets
    if keyboard.key_down.space
      bullets << {
        x: player[:x] + player[:w].half - 5,
        y: player[:y] + player[:h].half - 5,
        w: 10,
        h: 10,
        r: 0,
        g: 255,
        b: 0,
        direction: player[:direction]
      }
    end
  end

  def spawn_enemy
    enemies << {
      x: rand(CANVAS_W),
      y: rand(CANVAS_H),
      w: rand(50) + 30,
      h: rand(50) + 30,
      r: 0,
      g: 0,
      b: 255
    }
  end

  def check_for_collisions
    bullets.each do |bullet|
      enemies.each do |enemy|
        if GTK::Geometry.intersect_rect?(bullet, enemy)
          enemies.delete(enemy)
          bullets.delete(bullet)
        end
      end
    end
  end

  def render_everything
    solids << { x: 0, y: 0, w: CANVAS_W, h: CANVAS_H, r: 0, g: 0, b: 0 }
    solids << player
    solids << bullets
    solids << enemies
  end
end
