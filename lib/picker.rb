require 'disp3D'

module Disp3D
  class Picker
    def initialize(view)
      @view = view
      @max_select_count = 100
    end

    def pick(x,y)
      vp = GL.GetIntegerv(GL::VIEWPORT)

      selection = GL.SelectBuffer(@max_select_count)
      GL.RenderMode(GL::SELECT)

      GL.InitNames()
      GL.PushName(-1)
      GL.MatrixMode(GL::PROJECTION)
      GL.PushMatrix()
      GL.LoadIdentity()

      GLU.PickMatrix(x, vp[3] - y - 1, 1, 1, vp)
      @view.camera.set_screen(vp[2], vp[3])

      GL.MatrixMode(GL::MODELVIEW)

      @view.gl_display_world_scene_graph()

      GL.MatrixMode(GL::PROJECTION)
      GL.PopMatrix()
      GL.MatrixMode(GL::MODELVIEW)
      hit = GL.RenderMode(GL::RENDER)

      return nil if (hit < 0 || hit > 100000) # invalid hit count

      data = selection.unpack("I*")
      picked_result = Array.new()
      hit.times.each do | i |
        count = data[4*i]

        div = (0xffffffff).to_f
        near = data[4*i+1].to_f / div
        far = data[4*i+2].to_f / div
        return nil if ( count > 100000)# invalid hit count

        screen_pos = Vector3.new(x,y,near)
        unprojected = @view.camera.unproject(screen_pos)
        node_info = Array.new()
        count.times do | j |
          path_id = data[4*i+3 + j]
          picked_node = Node.from_path_id(path_id)
          if (picked_node != nil)
            parent_node = picked_node.parents.find {|parent| parent.include?(path_id) }
            picked_node_info = PathInfo.new(picked_node, parent_node, path_id)
            node_info.push(picked_node_info)
          end
        end
        picked_result.push(PickedResult.new(node_info, screen_pos, unprojected, near, far))
      end
      return picked_result
    end
  end
end
