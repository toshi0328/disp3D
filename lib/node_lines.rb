require 'disp3D'

module Disp3D
  class NodeLines < Node
    attr_accessor :width

    def draw
      pre_draw()

      if(@geom)
        GL.LineWidth(@width) if(@width)

        GL.Begin(GL::LINES)
        if(@geom.kind_of?(GMath3D::FiniteLine))
          GL.Vertex( @geom.start_point.x, @geom.start_point.y, @geom.start_point.z )
          GL.Vertex( @geom.end_point.x, @geom.end_point.y, @geom.end_point.z )
        elsif(@geom.kind_of?(Array))
          @geom.each do |line|
            GL.Vertex( line.start_point.x, line.start_point.y, line.start_point.z )
            GL.Vertex( line.end_point.x, line.end_point.y, line.end_point.z )
          end
        end
        GL.End()

        post_draw()
      end
    end

  end
end
