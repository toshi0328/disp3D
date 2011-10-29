# -*- coding: cp932 -*-
require 'disp3D'

module Disp3D
  class NodeLeaf < Node
    attr_accessor :geom

    attr_accessor :material_color
    attr_accessor :shininess

    def initialize(geometry)
      @geom = geometry

      @material_color = [1.0, 1.0, 1.0, 1.0]
      @shininess = nil
      @shininess_default = 32.0

      @node_id = new_id()
      @list_created = false
    end

    def draw
      draw_inner(self.method(:draw_element))
    end

protected
    def draw_inner(draw_element)
      diffuse = @material_color
      ambient = [@material_color[0]*0.5, @material_color[1]*0.5, @material_color[2]*0.5, 1]
      specular = [1,1,1,0.5]

      shineness = [@shiness]
      shineness = [@shininess_default] if( !@shiness )

      GL.Materialfv(GL::GL_FRONT, GL::GL_DIFFUSE, diffuse)
      GL.Materialfv(GL::GL_FRONT, GL::GL_AMBIENT, ambient)
      GL.Materialfv(GL::GL_FRONT, GL::GL_SPECULAR, specular)
      GL.Materialfv(GL::GL_FRONT, GL::GL_SHININESS, shineness)

      if(@list_created == false)
        @list_created = true
        GL.NewList(@node_id, GL::GL_COMPILE_AND_EXECUTE)
        pre_draw  # matrix manipulation
        draw_element.call
        post_draw # matrix manipulation
        GL.EndList()
      else
        GL.CallList(@node_id)
      end
    end

    def draw_element
    end

private
    @@id = 0
    def new_id()
      @@id += 1
      return @@id
    end
  end
end
