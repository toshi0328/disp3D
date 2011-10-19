require 'disp3D'

module Disp3D
  class NodePoints < Node
    attr_accessor :size

    def draw
      pre_draw()
      if(@geom)
        GL.PointSize(@size)

        GL.Begin(GL::POINTS)

        if(@geom.kind_of?(GMath3D::Vector3))
          GL.Vertex( @geom.x, @geom.y, @geom.z )
        elsif(@geom.kind_of?(Array))
          @geom.each do |point|
            GL.Vertex( point.x, point.y, point.z )
          end
        else
          #TODO error message
        end

        GL.End()
      end
      post_draw()
    end

    def initialize(geom)
      super(geom)
      @size = 3.0;
    end
  end
end
