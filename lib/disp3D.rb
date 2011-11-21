$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'gmath3D'

require 'opengl'
require 'glut'

require 'util'
require 'dsl'
require 'stl'

require 'gl_view'

require 'glut_window'

require 'camera'
require 'light'
require 'manipulator'
require 'compass'
require 'picker'
require 'node_info'
require 'picked_result'

require 'scene_graph'

require 'node/node'
require 'node/node_collection'
require 'node/node_leaf'

require 'node/node_tea_pod'
require 'node/node_text'
require 'node/node_points'
require 'node/node_lines'
require 'node/node_polylines'
require 'node/node_tris'
require 'node/node_arrows'
require 'node/node_coord'
require 'node/node_workplane'


module GMath3D
  class Quat
    # convert quat to array
    def to_array
      rot_mat = Matrix.from_quat(self)
      rot_mat_array = [
        [rot_mat[0,0], rot_mat[0,1], rot_mat[0,2], 0],
        [rot_mat[1,0], rot_mat[1,1], rot_mat[1,2], 0],
        [rot_mat[2,0], rot_mat[2,1], rot_mat[2,2], 0],
        [0,0,0,1]]
      return rot_mat_array
    end
  end
end
