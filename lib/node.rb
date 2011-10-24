require 'disp3D'

module Disp3D
  class Node
    attr_accessor :geom
    attr_accessor :translate
    attr_accessor :material_color
    attr_accessor :shininess

    def pre_draw
      diffuse = @material_color
      ambient = [@material_color[0]*0.5, @material_color[1]*0.5, @material_color[2]*0.5, 1]
      specular = [1,1,1,0.5]

      shineness = [@shiness]
      shineness = [@shininess_default] if( !@shiness )

      GL.Materialfv(GL::GL_FRONT, GL::GL_DIFFUSE, diffuse)
      GL.Materialfv(GL::GL_FRONT, GL::GL_AMBIENT, ambient)
      GL.Materialfv(GL::GL_FRONT, GL::GL_SPECULAR, specular)
      GL.Materialfv(GL::GL_FRONT, GL::GL_SHININESS, shineness)

      GL.PushMatrix()
      GL.Translate(translate[0], translate[1], translate[2]) if(@translate)
    end

    def post_draw
      GL.PopMatrix()
    end

    def initialize(geometry)
      @geom = geometry

      @translate = nil

      @material_color = [1.0, 1.0, 1.0, 1.0]
      @shininess = nil
      @shininess_default = 32.0
    end
  end
end
