require 'disp3D'

module Disp3D
  class PickedResult
    attr_reader :near
    attr_reader :far
    attr_reader :nodes
    attr_reader :world_position
    attr_reader :screen_position

    def initialize(near, far, nodes, screen_position, world_position)
      @near = near
      @far = far
      @nodes = nodes
      @screen_position = screen_position
      @world_position = world_position
    end
  end
end
