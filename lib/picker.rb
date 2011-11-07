require 'disp3D'

module Disp3D
  class Picker
    def initialize(view)
      @view = view
      @max_select_count = 100
    end

    def hit_test(x,y)
      vp = GL.GetIntegerv(GL::VIEWPORT)
      projection = GL::GetDoublev(GL::PROJECTION_MATRIX)
      model_view = GL::GetDoublev(GL::MODELVIEW_MATRIX)

      selection = GL.SelectBuffer(@max_select_count)
      GL.RenderMode(GL::SELECT)

      GL.InitNames()
      GL.PushName(-1)
      GL.MatrixMode(GL::PROJECTION)
      GL.PushMatrix()
      GL.LoadIdentity()

      GLU.PickMatrix(x, vp[3] - y - 1, 6, 6, vp)
      @view.camera.set_screen(vp[2], vp[3])

      GL.MatrixMode(GL::MODELVIEW)

      @view.gl_display_world_scene_graph()

      GL.MatrixMode(GL::PROJECTION)
      GL.PopMatrix()
      GL.MatrixMode(GL::MODELVIEW)
      hit = GL.RenderMode(GL::RENDER)

      return nil if (hit < 0 || hit > 100000) # invalid hit count


      p "model view" + model_view.to_s
      p "projection view" + projection.to_s
      p "view port" + vp.to_s

      data = selection.unpack("I*")
      picked_result = Array.new()
      hit.times.each do | i |
        count = data[4*i]
        near = data[4*i+1].to_f / (0x7fffffff).to_f
        far = data[4*i+2].to_f / (0x7fffffff).to_f
        return nil if ( count > 100000)# invalid hit count

        # TODO! get world cod
        mid_z = (near+far)/2.0
        screen_pos = Vector3.new(x,y,mid_z)
        p "screen_pos " + screen_pos.to_s

        unprojected = GLU::UnProject(x,y,mid_z, model_view, projection, vp)
        nodes = Array.new()
        count.times do | j |
          picked_node = Node.from_id(data[4*i+3 + j])
          nodes.push(picked_node) if (picked_node != nil)
        end
        picked_result.push(PickedResult.new(near, far, nodes, screen_pos, unprojected))
      end
      return picked_result
    end
  end
end
