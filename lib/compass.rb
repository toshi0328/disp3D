require 'disp3D'

module Disp3D
  class Compass
    def initialize(camera)
      @camera = camera
    end

    def node_coord
      dmy, dmy, screen_width, screen_height = @camera.viewport
      coord_size = [screen_width, screen_height].min
      scalling_factor = 0.003
      coord_size *= scalling_factor
      @coord_pos = Vector3.new(-screen_width*scalling_factor*2.5, -screen_height*scalling_factor*2.5, 0.0)
      node = NodeCoord.new(Vector3.new(), coord_size)
      return node
    end

    def gl_display
      GL.LoadIdentity()
      GL.PushMatrix()
      @camera.apply_position()

      node = node_coord

      GL.Translate(@coord_pos.x, @coord_pos.y, @coord_pos.z)
      @camera.apply_rotation()
      node.draw if( !node.nil? )
      GL.PopMatrix()
    end
  end
end
