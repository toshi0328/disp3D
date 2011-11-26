require 'disp3D'

module Disp3D
  class PickedResult
    attr_reader :node_path_info # Array of NodeInfo
    attr_reader :world_position
    attr_reader :screen_position
    attr_reader :near
    attr_reader :far

    def initialize(node_path_info_ary, screen_position, world_position, near, far)
      Util3D.check_arg_type(Array, node_path_info_ary)
      Util3D.check_arg_type(Vector3, screen_position)
      Util3D.check_arg_type(Vector3, world_position)
      Util3D.check_arg_type(::Numeric, near)
      Util3D.check_arg_type(::Numeric, far)

      @node_path_info = node_path_info_ary
      @screen_position = screen_position
      @world_position = world_position
      @near = near
      @far = far
    end
  end
end
