require 'disp3D'

module Disp3D
  class Picker
    def initialize(view)
      @view = view
      @max_select_count = 100
    end

    def hit_test(x,y)
      selection = GL.SelectBuffer(@max_select_count)
      GL.RenderMode(GL::SELECT)

      GL.InitNames()
      GL.PushName(-1)
      GL.MatrixMode(GL::PROJECTION)
      GL.PushMatrix()
      GL.LoadIdentity()
      vp = GL.GetIntegerv(GL::VIEWPORT)

      GLU.PickMatrix(x, vp[3] - y - 1, 6, 6, vp)
      @view.camera.set_screen(vp[2], vp[3])

      GL.MatrixMode(GL::MODELVIEW)

      @view.camera.display()
      @view.world_scene_graph.display()

      GL.MatrixMode(GL::PROJECTION)

      GL.PopMatrix()
      GL.MatrixMode(GL::MODELVIEW)
      hit = GL.RenderMode(GL::RENDER)

      return nil if (hit < 0 || hit > 100000) # invalid hit count

      data = selection.unpack("I*")
      picked_result = Array.new()
      hit.times.each do | i |
        count = data[4*i]
        near = data[4*i+1].to_f / (0x7fffffff).to_f
        far = data[4*i+2].to_f / (0x7fffffff).to_f
        return nil if ( count > 100000)# invalid hit count

        # TODO! get world cod
        nodes = Array.new()
        count.times do | j |
          picked_node = Node.from_id(data[4*i+3 + j])
          nodes.push(picked_node) if (picked_node != nil)
        end
        picked_result.push(PickedResult.new(near, far, nodes))
      end
      return picked_result
    end
  end
end
