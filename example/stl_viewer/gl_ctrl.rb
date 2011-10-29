require 'stl_viewer'

class GLCtrl
  def initialize(gl_widget)
    @gl_widget = gl_widget
  end

  def add2scenegraph(mesh_info)
    mesh_info.mesh_node = Disp3D::NodeTris.new(mesh_info.mesh_geom)
    mesh_info.mesh_node.material_color = [1,0,0,1]
    @gl_widget.world_scene_graph.add(mesh_info.mesh_node)
    @gl_widget.updateGL
  end
end
