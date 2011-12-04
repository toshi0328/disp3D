# -*- coding: cp932 -*-
require 'disp3D'

module Disp3D
  class NodeLeaf < Node
    attr_for_disp :material_color
    attr_for_disp :colors
    attr_for_disp :shininess

    def initialize(geometry = nil, name = nil)
      Util3D.check_arg_type(Symbol, name, true)
      Util3D.check_arg_type(GMath3D::Geom, geometry, true, true)
      super(name)
      @geom = geometry

      @material_color = [1,1,1,1]
      @shininess = nil
      @shininess_default = 32.0

      @dislay_list_created = nil
    end

    def draw currnet_view
      draw_inner(self.method(:draw_element), currnet_view)
    end

    def box
      return nil if @geom == nil
      if(@geom.kind_of?(Array))
        return nil if @geom.size == 0
        rtn_box = @geom[0].box
        @geom.each do |element|
          rtn_box += element.box
        end
      else
        rtn_box = @geom.box
      end
      return box_transform(rtn_box)
    end

    def update
      @dislay_list_created = nil
    end
protected
    def draw_inner(draw_element, current_view)
      # colorsが設定されていたら、そちらを優先的に表示する。その際、ライティングはオフにする必要がある
      if(@colors.nil?)
        GL.Enable(GL::GL_LIGHTING)
        diffuse = @material_color
        ambient = [@material_color[0]*0.5, @material_color[1]*0.5, @material_color[2]*0.5, 1]
        specular = [1,1,1,0.5]

        shineness = [@shiness]
        shineness = [@shininess_default] if( !@shiness )

        GL.Materialfv(GL::GL_FRONT, GL::GL_DIFFUSE, diffuse)
        GL.Materialfv(GL::GL_FRONT, GL::GL_AMBIENT, ambient)
        GL.Materialfv(GL::GL_FRONT, GL::GL_SPECULAR, specular)
        GL.Materialfv(GL::GL_FRONT, GL::GL_SHININESS, shineness)
      else
        GL.Disable(GL::GL_LIGHTING)
      end

      if(@dislay_list_created.nil? || @dislay_list_created[current_view] == nil)
        @dislay_list_created ||= Hash.new()
        @dislay_list_created[current_view] = true
        GL.NewList(self.instance_id, GL::COMPILE_AND_EXECUTE)
        pre_draw  # matrix manipulation
        draw_element.call
        post_draw # matrix manipulation
        GL.EndList()
      else
        GL.CallList(self.instance_id)
      end
    end

    def draw_element
      # you cannot call this directory. use child class one.
      raise
    end

    def draw_color
      if(@colors.nil?)
        GL.Color(1,1,1,1)
      elsif(!@colors[0].kind_of?(Array))
        GL.Color(@colors[0], @colors[1], @colors[2], @colors[3])
      end
    end

    def draw_colors(i)
      if(!@colors.nil? and !@colors[i].nil? and @colors[i].kind_of?(Array))
        GL.Color(@colors[i][0], @colors[i][1], @colors[i][2], @colors[i][3])
      end
    end
  end
end
