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

      GLU.PickMatrix(x, vp[3] - y - 1, 1, 1, vp)
      @view.camera.set_screen(vp[2], vp[3])

      GL.MatrixMode(GL::MODELVIEW)

      @view.camera.display()
      @view.world_scene_graph.display_with_name()

      GL.MatrixMode(GL::PROJECTION)

      GL.PopMatrix()
      GL.MatrixMode(GL::MODELVIEW)
      hit = GL.RenderMode(GL::RENDER)

# TODO create and return PickResult
      p "hit: #{hit}"
return if (hit < 0 || hit > 1000)
      data = selection.unpack("I*")
      hit.times.each do | i |
        count = data[4*i]
        near = data[4*i+1].to_f / (0x7fffffff).to_f
        far = data[4*i+2].to_f / (0x7fffffff).to_f
        p "near: #{near}"
        p "far: #{far}"
        p "count: #{count}"

return if ( count > 1000)
        count.times do | j |
          named_obj = data[4*i+3 + j]
p named_obj
        end
      end
      return nil
    end
  end
end
