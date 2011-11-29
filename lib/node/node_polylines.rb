require 'disp3D'

module Disp3D
  class NodePolylines < NodeLeaf
    attr_accessor :width

    def initialize(geom = nil, name = nil)
      super
      @width = 1.0
    end

protected
    def draw_element
      if(@geom)
        GL.LineWidth(@width)
        draw_color
        if(@geom.kind_of?(GMath3D::Polyline))
          draw_each(@geom)
        elsif(@geom.kind_of?(Array))
          @geom.each_with_index do |polyline, i|
            draw_colors
            draw_each(polyline)
          end
        end
      end
    end

    def draw_each(polyline)
      GL.Begin(GL::LINE_STRIP)
      polyline.vertices.each do | vertex |
        GL.Vertex( vertex.x, vertex.y, vertex.z )
      end
      GL.Vertex( polyline.vertices[0].x, polyline.vertices[0].y, polyline.vertices[0].z ) if( !polyline.is_open )
      GL.End()
    end

  end
end


