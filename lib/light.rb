require 'disp3D'

module Disp3D
  class Light
    def gl_display()
      idx = 0
      GL.Enable(GL::GL_LIGHTING)
      all_disable = true
      @enable.each do | enable |
        if(enable)
          GL.Enable( @light_id[idx])
          GL.Lightfv( @light_id[idx], GL::GL_POSITION, @position[idx] )
          GL.Lightfv( @light_id[idx], GL::GL_DIFFUSE,  @deffuse[idx]  )
          GL.Lightfv( @light_id[idx], GL::GL_AMBIENT,  @ambient[idx]  )
          GL.Lightfv( @light_id[idx], GL::GL_SPECULAR, @specular[idx] )
          all_disable = false
        end
      end
      if(all_disable)
        GL.Enable(@light_id[0])
      end
    end

    def initialize()
      @diffuse_default = [0.7, 0.7, 0.7, 1]
      @ambient_default = [0.2, 0.2, 0.2, 1]
      @specular_default = [1, 1, 1, 1]
      @position_default = [0.0, 0.0, 1.0, 0.0]

      light_count = 8 # openGL spec

      @enable = [false, false, false, false, false, false, false, false]
      @deffuse = Array.new(light_count, @diffuse_default)
      @ambient = Array.new(light_count, @ambient_default)
      @specular = Array.new(light_count, @specular_default)
      @position = Array.new(light_count, @position_default)
      @light_id = Array.new(light_count)
      @light_id[0] = GL::GL_LIGHT0
      @light_id[1] = GL::GL_LIGHT1
      @light_id[2] = GL::GL_LIGHT2
      @light_id[3] = GL::GL_LIGHT3
      @light_id[4] = GL::GL_LIGHT4
      @light_id[5] = GL::GL_LIGHT5
      @light_id[6] = GL::GL_LIGHT6
      @light_id[7] = GL::GL_LIGHT7
    end

  end
end
