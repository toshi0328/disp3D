# -*- coding: cp932 -*-
require 'disp3D'

module Disp3D
  class NodeLeaf < Node
    attr_accessor :material_color
    attr_accessor :shininess

    def initialize(geometry = nil)
      @geom = geometry

      @material_color = [1.0, 1.0, 1.0, 1.0]
      @shininess = nil
      @shininess_default = 32.0

      @node_id = new_id()
      @list_created = false
    end

    def draw
      @@named_nodes[@node_id] = self
      GL.LoadName(@node_id)
      draw_inner(self.method(:draw_element))
    end

    def box
      return nil if @geom == nil
      if(@geom.kind_of?(Array))
        return nil if @geom.size == 0
        box = @geom[0].box
        @geom.each do |element|
          box += element.box
        end
      return box
      else
        return @geom.box
      end
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
      # you cannot call this directory. use child class one.
      raise
    end

private
    @@id_list = Array.new()
    def new_id()
#      p "constructed id list #{@@id_list}"
      id_adding = GL.GenLists(1)
      @@id_list.push(id_adding)
      return id_adding
    end
  end
end
