require 'disp3D'

module Disp3D
  class PathInfo
    attr_reader :node
    attr_reader :parent_node
    attr_reader :path_id

    def initialize(node, parent_node, path_id)
      Util3D.check_arg_type(Node, node)
      Util3D.check_arg_type(NodeCollection, parent_node)
      Util3D.check_arg_type(::Integer, path_id)

      @node = node
      @parent_node = parent_node
      @path_id = path_id
    end
  end

end
