require 'disp3D'

module Disp3D
  class Node
    active_node = nil
    def self.create_group (node_name)
      new_node = NodeCollection.new()
      yield(new_node)
    end

    def add_point(*args)
#      Util3D.check_key_arg(args, :geom)
#      Util3D.check_key_arg(args, :geom)

    end
  end
end
