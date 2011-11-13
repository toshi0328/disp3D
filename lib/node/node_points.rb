require 'disp3D'

module Disp3D
  class NodePoints < NodeLeaf
    attr_accessor :size

    def initialize(geom)
      super(geom)
      @size = 3.0
    end

protected
    def draw_element
      if(@geom)
        GL.PointSize(@size)
        draw_color
        GL.Begin(GL::POINTS)
        if(@geom.kind_of?(GMath3D::Vector3))
          GL.Vertex( @geom.x, @geom.y, @geom.z )
        elsif(@geom.kind_of?(Array))
          @geom.each_with_index do |point, i|
            draw_colors(i)
            GL.Vertex( point.x, point.y, point.z )
          end
        else
          #TODO error message
        end

        GL.End()
      end
    end
  end
end
