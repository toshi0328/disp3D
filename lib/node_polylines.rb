require 'disp3D'

module Disp3D
  class NodePolylines < NodeLeaf
    attr_accessor :width

protected
    def draw_element
      if(@geom)
        GL.ShadeModel(GL::FLAT)
        GL.LineWidth(@width) if(@width)
        if(@geom.kind_of?(GMath3D::Polyline))
          draw_each(@geom)
        elsif(@geom.kind_of?(Array))
          @geom.each do |polyline|
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


