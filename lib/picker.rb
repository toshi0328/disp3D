require 'disp3D'

module Disp3D
  class Picker
    attr_reader :pick_mode
    # pick modes
    NONE = 0
    RECT_PICK = 1

    def initialize(view)
      @view = view
      @max_select_count = 100
      @pick_mode = NONE
    end

    def pick(x, y, width = 1, height = 1)
      vp = GL.GetIntegerv(GL::VIEWPORT)

      selection = GL.SelectBuffer(@max_select_count)
      GL.RenderMode(GL::SELECT)

      GL.InitNames()
      GL.PushName(-1)
      GL.MatrixMode(GL::PROJECTION)
      GL.PushMatrix()
      GL.LoadIdentity()

      GLU.PickMatrix(x, vp[3] - y - 1, width, height, vp)
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
          picked_node = NodePathDB.find_by_path_id(path_id)
          if (picked_node != nil)
            parent_node = picked_node.parents.find {|parent| parent.include?(path_id) }
            picked_node_info = PathInfo.new(picked_node, parent_node, path_id)
            node_info.push(picked_node_info)
          end
        end
        picked_result.push(PickedResult.new(node_info, screen_pos, unprojected, near, far))
      end
      @pick_done_process.call(picked_result) if(!@pick_done_process.nil?)
      return picked_result
    end

    def mouse(button,state,x,y)
      if(button == GLUT::GLUT_LEFT_BUTTON && state == GLUT::GLUT_DOWN)
        @last_pos = Vector3.new(x, y)
        @rubber_band = false
      elsif(button == GLUT::GLUT_LEFT_BUTTON && state == GLUT::GLUT_UP)
        if(@pick_mode == RECT_PICK)
          draw_rubber_band(Box.new(@last_pos, @save_pos)) # delete rubber band
          pick_x = (x + @last_pos.x)/2
          pick_y = (y + @last_pos.y)/2
          width  = (x - @last_pos.x).abs
          height = (y - @last_pos.y).abs
          pick(pick_x, pick_y, width, height)
        end
        @save_pos = nil
        @last_pos = nil
        @rubber_band = false
      end
    end

    # return if picking process is in progress?
    def motion(x,y)
      return false if(@pick_mode == NONE || @last_pos.nil?)
      if(@pick_mode == RECT_PICK)
        if(@rubber_band)
          draw_rubber_band([Box.new(@last_pos, @save_pos), Box.new(@last_pos, Vector3.new(x,y))])
        else
          draw_rubber_band(Box.new(@last_pos, Vector3.new(x,y)))
        end
        @save_pos = Vector3.new(x, y)
        @rubber_band=true
        return true
      end
    end

    def start_rect_pick(&block)
      @pick_mode = RECT_PICK
      @pick_done_process = block
    end

    def end_rect_pick
      @pick_mode = NONE
      @pick_done_process = nil
    end

private
    def pre_rubber_band_process
      dmy,dmy, w,h = GL.GetIntegerv(GL::VIEWPORT)
      @view.camera.set_projection_for_camera_scene
      GL.MatrixMode(GL::GL_MODELVIEW)
      GL.PushMatrix()
      GL.LoadIdentity()
      GLU.LookAt(0, 0, 1, 0, 0, 0, 0, 1, 0)

      GL.Enable(GL::COLOR_LOGIC_OP)
      GL.LogicOp(GL::INVERT)
      GL.DrawBuffer( GL::FRONT )

      GL.LineWidth(2)

      return w,h
    end

    def post_rubber_band_process
      GL.Flush()

      GL.Disable(GL::COLOR_LOGIC_OP)
      GL.LogicOp(GL::COPY)

      GL.PopMatrix()
    end

    # [Input]
    #  _elemnets_ should be FiniteLine or Box or Array of them.
    def draw_rubber_band(elements)
      w,h = pre_rubber_band_process
      draw_rubber_band_lines_inner(elements, w, h)
      post_rubber_band_process
    end

    def screen_to_rubberband( vec, w , h )
      [-w/2 + vec.x, h/2 - vec.y - 1]
    end

    def draw_rubber_band_lines_inner(elements, w, h)
      return if(elements.nil?)
      if(elements.kind_of?(FiniteLine))
        GL.Begin(GL::LINES)
        GL.Vertex(screen_to_rubberband( elements.start_point, w, h ))
        GL.Vertex(screen_to_rubberband( elements.end_point, w, h  ))
        GL.End()
      elsif(elements.kind_of?(Box))
        box = elements
        lines = Array.new(4)
        lines[0] = FiniteLine.new(Vector3.new(box.min_point.x, box.min_point.y), Vector3.new(box.max_point.x, box.min_point.y))
        lines[1] = FiniteLine.new(Vector3.new(box.max_point.x, box.min_point.y), Vector3.new(box.max_point.x, box.max_point.y))
        lines[2] = FiniteLine.new(Vector3.new(box.max_point.x, box.max_point.y), Vector3.new(box.min_point.x, box.max_point.y))
        lines[3] = FiniteLine.new(Vector3.new(box.min_point.x, box.max_point.y), Vector3.new(box.min_point.x, box.min_point.y))
        draw_rubber_band_lines_inner(lines, w, h)
      elsif(elements.kind_of?(Array))
        elements.each do |item|
          draw_rubber_band_lines_inner(item, w, h)
        end
      end
    end
  end
end
