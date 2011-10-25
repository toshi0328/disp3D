require 'disp3D'

module Disp3D
  class NodePolylines < Node
    attr_accessor :width

    def draw
      pre_draw()

      if(@geom)
        GL.LineWidth(@width) if(@width)
        if(@geom.kind_of?(GMath3D::Polyline))
          draw_inner(@geom)
        elsif(@geom.kind_of?(Array))
          @geom.each do |polyline|
            draw_inner(polyline)
          end
        end
      end
      post_draw()
    end

    def draw_inner(polyline)
      GL.Begin(GL::LINE_STRIP)
      polyline.vertices.each do | vertex |
        GL.Vertex( vertex.x, vertex.y, vertex.z )
      end
      GL.Vertex( polyline.vertices[0].x, polyline.vertices[0].y, polyline.vertices[0].z ) if( polyline.is_open )
      GL.End()
    end

  end
end


