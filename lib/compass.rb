require 'disp3D'

module Disp3D
  class Compass
    def initialize(camera)
      @camera = camera
    end

    def node_coord
      dmy, dmy, screen_width, screen_height = @camera.viewport
      coord_size = [screen_width, screen_height].min
      scalling_factor = 0.1
      coord_size *= scalling_factor
      @coord_pos = Vector3.new(-screen_width*0.5 + coord_size*1.5, -screen_height*0.5 + coord_size*1.5, 0.0)
      node = NodeCoord.new(nil, Vector3.new(), coord_size)
      return node
    end

    def gl_display current_view
      GL.PushMatrix()
      GL.LoadIdentity()
      node = node_coord
      GL.Translate(@coord_pos.x, @coord_pos.y, @coord_pos.z)
      @camera.apply_rotate
      node.draw current_view if( !node.nil? )
      GL.PopMatrix()
    end
  end
end
