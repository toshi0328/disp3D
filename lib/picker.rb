require 'disp3D'

module Disp3D
  class Picker
    attr_reader :pick_mode
    attr_accessor :max_select_count

    # pick modes
    NONE = 0
    POINT_PICK = 1
    LINE_PICK = 2
    RECT_PICK = 3

    def initialize(view)
      @view = view
      @max_select_count = 100
      @pick_mode = NONE
    end

    def point_pick(x,y)
      pick(x, y)
    end

    def post_picked(&block)
      @post_pick_process = block
    end

    def start_point_pick(&block)
      @pick_mode = POINT_PICK
      post_picked(&block) if(block_given?)
    end

    def start_line_pick(&block)
      @pick_mode = LINE_PICK
      post_picked(&block) if(block_given?)
    end

    def start_rect_pick(&block)
      @pick_mode = RECT_PICK
      post_picked(&block) if(block_given?)
    end

    def end_pick
      @pick_mode = NONE
    end

    # users donot need to use this.
    def mouse(button,state,x,y)
      return if(@pick_mode == NONE)
      if(button == GLUT::GLUT_LEFT_BUTTON && state == GLUT::GLUT_DOWN)
        if(@pick_mode == POINT_PICK)
          picked_result = point_pick(x,y)
          @post_pick_process.call(picked_result) if(!@post_pick_process.nil?)
          return
        elsif(@pick_mode == LINE_PICK)
          @line_start_result = point_pick(x,y)
        end
        @last_pos = Vector3.new(x, y)
        @rubber_band = false
      elsif(button == GLUT::GLUT_LEFT_BUTTON && state == GLUT::GLUT_UP)
        if(@pick_mode == LINE_PICK)
          draw_rubber_band(FiniteLine.new(@last_pos, @save_pos)) # delete rubber band
          line_end_result =  pick(x, y)
          @post_pick_process.call(@line_start_result, line_end_result) if(!@post_pick_process.nil?)
          @line_start_result = nil
        elsif(@pick_mode == RECT_PICK)
          draw_rubber_band(Box.new(@last_pos, @save_pos)) # delete rubber band
          pick_x = (x + @last_pos.x)/2
          pick_y = (y + @last_pos.y)/2
          width  = (x - @last_pos.x).abs
          height = (y - @last_pos.y).abs
          picked_result = pick(pick_x, pick_y, width, height)
          @post_pick_process.call(picked_result) if(!@post_pick_process.nil?)
        end
        @save_pos = nil
        @last_pos = nil
        @rubber_band = false
      end
    end

    # users donot need to use this.
    # return if picking process is in progress?
    def motion(x,y)
      return false if(@pick_mode == NONE || @last_pos.nil?)
      if(@pick_mode == LINE_PICK)
        if(@rubber_band)
          draw_rubber_band([FiniteLine.new(@last_pos, @save_pos), FiniteLine.new(@last_pos, Vector3.new(x,y))])
        else
          draw_rubber_band(FiniteLine.new(@last_pos, Vector3.new(x,y)))
        end
      elsif(@pick_mode == RECT_PICK)
        if(@rubber_band)
          draw_rubber_band([Box.new(@last_pos, @save_pos), Box.new(@last_pos, Vector3.new(x,y))])
        else
          draw_rubber_band(Box.new(@last_pos, Vector3.new(x,y)))
        end
      end
      @save_pos = Vector3.new(x, y)
      @rubber_band=true
      return true
    end

private
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
      return picked_result
    end

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
