require 'disp3D'

module Disp3D
  class Compass
    def initialize(camera)
      @camera = camera
    end

    def node_coord
      width_at_z_zero, height_at_z_zero = @camera.screen_size_at_z_zero
      coord_size = [width_at_z_zero, height_at_z_zero].min
      coord_size /= (8*10)
      @coord_pos = Vector3.new(-3.0/100*width_at_z_zero, -3.0/100*height_at_z_zero, 0)
      node = NodeCoord.new(Vector3.new(-coord_size/4.0, -coord_size/4.0, 0.0), coord_size)
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
