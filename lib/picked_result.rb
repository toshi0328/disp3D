require 'disp3D'

module Disp3D
  class PickedResult
    attr_reader :nodes
    attr_reader :world_position
    attr_reader :screen_position

    def initialize(nodes, screen_position, world_position)
      @nodes = nodes
      @screen_position = screen_position
      @world_position = world_position
    end
  end
end
