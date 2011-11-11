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
require 'picked_result'
require 'scene_graph'

require 'node'
require 'node_collection'
require 'node_leaf'

require 'node_tea_pod'
require 'node_text'

require 'node_points'
require 'node_lines'
require 'node_polylines'
require 'node_tris'

require 'node_arrows'
require 'node_coord'
require 'node_workplane'
