require 'disp3D'

module Disp3D
  class Compass
    def initialize(camera)
      @camera = camera
      @coord_node = NodeCoord.new(nil, Vector3.new(), coord_size)
    end

    def gl_display current_view
      GL.PushMatrix()
      GL.LoadIdentity()
      GL.Translate(coord_pos.x, coord_pos.y, coord_pos.z)
      @camera.apply_rotate
      @coord_node.draw current_view
      GL.PopMatrix()
    end

    def update
      @coord_node.length = coord_size
    end

private
    def coord_pos
      dmy, dmy, screen_width, screen_height = @camera.viewport
      Vector3.new(-screen_width*0.5 + coord_size*1.5, -screen_height*0.5 + coord_size*1.5, 0.0)
    end

    def coord_size
      dmy, dmy, screen_width, screen_height = @camera.viewport
      coord_size = [screen_width, screen_height].min
      scalling_factor = 0.1
      coord_size *= scalling_factor
    end
  end
end
