require 'disp3D'

module Disp3D
  class NodeLines < NodeLeaf
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
        GL.Begin(GL::LINES)
        if(@geom.kind_of?(GMath3D::FiniteLine))
          GL.Vertex( @geom.start_point.x, @geom.start_point.y, @geom.start_point.z )
          GL.Vertex( @geom.end_point.x, @geom.end_point.y, @geom.end_point.z )
        elsif(@geom.kind_of?(Array))
          @geom.each_with_index do |line, i|
            draw_colors(i)
            GL.Vertex( line.start_point.x, line.start_point.y, line.start_point.z )
            GL.Vertex( line.end_point.x, line.end_point.y, line.end_point.z )
          end
        end
        GL.End()
      end
    end

  end
end
