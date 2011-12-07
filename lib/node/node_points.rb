require 'disp3D'

module Disp3D
  class NodePoints < NodeLeaf
    attr_for_disp :size

    def initialize(geom, name = nil)
      Util3D.check_arg_type(Symbol, name, true)
      Util3D.check_arg_type(GMath3D::Vector3, geom, false, true)
      super
      @size = 2.0
    end

protected
    def draw_element
      if(@geom)
        GL.PointSize(@size)
        draw_color
        GL.Enable(GL::POINT_SMOOTH)
        GL.Begin(GL::POINTS)
        if(@geom.kind_of?(GMath3D::Vector3))
          GL.Vertex( @geom.x, @geom.y, @geom.z )
        elsif(@geom.kind_of?(Array))
          @geom.each_with_index do |point, i|
            draw_colors(i)
            GL.Vertex( point.x, point.y, point.z )
          end
        else
          raise
        end
        GL.End()
      end
    end
  end
end
