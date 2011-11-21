require 'disp3D'

module Disp3D
  class PickedResult
    attr_reader :node_info # Array of NodeInfo
    attr_reader :world_position
    attr_reader :screen_position
    attr_reader :near
    attr_reader :far

    def initialize(node_info, screen_position, world_position, near, far)
      @node_info = node_info
      @screen_position = screen_position
      @world_position = world_position
      @near = near
      @far = far
    end
  end
end
