require 'disp3D'

module Disp3D
  class NodeCoord < NodeCollection
    attr_for_disp :length
    attr_for_disp :base_position

    def initialize(name = nil, base_position = Vector3.new(), length = 1)
      super(name)
      @length = length
      @base_position = base_position
      @x_color = [1,0,0,1]
      @y_color = [0,1,0,1]
      @z_color = [0,0,1,1]

      @x_node = NodeArrows.new(geom[0])
      @y_node = NodeArrows.new(geom[1])
      @z_node = NodeArrows.new(geom[2])
      @x_node.colors = @x_color
      @y_node.colors = @y_color
      @z_node.colors = @z_color
      add(@x_node)
      add(@y_node)
      add(@z_node)
    end

    def update
      @x_node.geom = geom[0]
      @y_node.geom = geom[1]
      @z_node.geom = geom[2]
      super
    end

private
    def geom
      x_geom = FiniteLine.new(@base_position, @base_position + Vector3.new(@length,0,0))
      y_geom = FiniteLine.new(@base_position, @base_position + Vector3.new(0,@length,0))
      z_geom = FiniteLine.new(@base_position, @base_position + Vector3.new(0,0,@length))
      return [x_geom, y_geom, z_geom]
    end
  end
end
