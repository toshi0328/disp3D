require 'disp3D'

module Disp3D
  class NodeCoord < NodeCollection
    def initialize(base_position = Vector3.new(), length = 1)
      super()
      @length = length
      @base_position = base_position
      @x_color = [1,0,0,1]
      @y_color = [0,1,0,1]
      @z_color = [0,0,1,1]

      x_geom = FiniteLine.new(@base_position, @base_position + Vector3.new(@length,0,0))
      y_geom = FiniteLine.new(@base_position, @base_position + Vector3.new(0,@length,0))
      z_geom = FiniteLine.new(@base_position, @base_position + Vector3.new(0,0,@length))
      x_node = NodeArrows.new(x_geom)
      y_node = NodeArrows.new(y_geom)
      z_node = NodeArrows.new(z_geom)
      x_node.colors = @x_color
      y_node.colors = @y_color
      z_node.colors = @z_color
      @children.push(x_node)
      @children.push(y_node)
      @children.push(z_node)
    end
  end
end
