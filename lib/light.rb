require 'disp3D'

module Disp3D
  class Light
     attr_accessor :enable
     attr_accessor :diffuse
     attr_accessor :ambient
     attr_accessor :specular
     attr_accessor :position
     attr_accessor :spot_direction

    def initialize()
      @diffuse_default = [0.7, 0.7, 0.7, 1]
      @ambient_default = [0.2, 0.2, 0.2, 1]
      @specular_default = [1, 1, 1, 1]
      @position_default = Vector3.new(0.0, 0.0, 1.0)
      @spot_direction_default = Vector3.new(0.0, 0.0, -1.0)

      light_count = 8 # openGL spec

      @enable = [false, false, false, false, false, false, false, false]
      @diffuse = Array.new(light_count, @diffuse_default)
      @ambient = Array.new(light_count, @ambient_default)
      @specular = Array.new(light_count, @specular_default)
      @position = Array.new(light_count, @position_default)
      @spot_direction = Array.new(light_count, @spot_direction_default)
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

    def gl_display()
      GL.Enable(GL::GL_LIGHTING)
      @enable.each_with_index do | enable, idx |
        if(enable)
          GL.Enable( @light_id[idx])
#p @position[idx]
#p @spot_direction[idx]
          GL.Lightfv( @light_id[idx], GL::POSITION, [@position[idx].x,@position[idx].y,@position[idx].z] )
          GL.Lightfv( @light_id[idx], GL::SPOT_DIRECTION, [@spot_direction[idx].x,@spot_direction[idx].y,@spot_direction[idx].z] )
          GL.Lightfv( @light_id[idx], GL::DIFFUSE,  @diffuse[idx]  )
          GL.Lightfv( @light_id[idx], GL::AMBIENT,  @ambient[idx]  )
          GL.Lightfv( @light_id[idx], GL::SPECULAR, @specular[idx] )
        end
      end
      if(!@enable.include?(true))
        GL.Enable(@light_id[0])
      end
    end

    def open(&block)
      self.instance_eval(&block)
    end

private
    def set(hash)
      Util3D.check_key_arg(hash, :id)
      target_idx = hash[:id]
      hash.each do | key, value |
        next if( key == :id)
        target_ary = eval "@#{key.to_s}"
        target_ary[target_idx]=value
      end
    end
  end
end
