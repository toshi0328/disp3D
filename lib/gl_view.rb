require 'disp3D'
require 'rmagick'

module Disp3D
  # GLView class hold primary object for 3D displaying like camera, scene_graph.
  # User never use this class
  # Use QtWidgetGL class (in Qt Application)
  # Use GLUTWindow class (in GLUT Window)
  class GLView
    attr_reader :world_scene_graph
    attr_reader :camera_scene_graph
    attr_reader :camera
    attr_reader :manipulator
    attr_reader :light
    attr_reader :picker

    attr_accessor :bk_color

    def initialize(width, height, vert_filename, frag_filename)
      GL.FrontFace(GL::GL_CW)

      GL.Enable(GL::GL_AUTO_NORMAL)
      GL.Enable(GL::GL_NORMALIZE)

      GL.Enable(GL::GL_DEPTH_TEST)
      GL.DepthFunc(GL::GL_LESS)

      GL.Enable(GL::BLEND)
      GL.BlendFunc(GL::GL_SRC_ALPHA, GL::GL_ONE_MINUS_SRC_ALPHA)

      @light = Light.new()
      @camera = Camera.new()

      @world_scene_graph = SceneGraph.new()
      @camera_scene_graph = SceneGraph.new()

      @picker = Picker.new(self)
      @bk_color = [0.28,0.23,0.55,1]

      @manipulator = Manipulator.new(@camera, @picker)
      @compass = Compass.new(@camera)

      @mouse_move_proc = nil
      @mouse_press_proc = nil
      @mouse_release_proc = nil
      init_shader(vert_filename, frag_filename)
    end

    def sync_to target_view
      @world_scene_graph = target_view.world_scene_graph
    end

    def capture
      dmy,dmy, w, h = @camera.viewport
      gl_display
      GL.ReadBuffer(GL::FRONT)
      GL.PixelStorei(GL::UNPACK_ALIGNMENT,1)
      data = GL.ReadPixels(0,0,w,h,GL::RGB, GL::UNSIGNED_BYTE)
      data_ary = data.unpack("C*")
      data_index = -1
      max_color_intensity =  Magick::QuantumRange.to_f
      pixels = Array.new(w*h).collect do | elem |
          r = data_ary[data_index+=1]
          g = data_ary[data_index+=1]
          b = data_ary[data_index+=1]
          elem = Magick::Pixel.new(
                                   r/255.0*max_color_intensity,
                                   g/255.0*max_color_intensity,
                                   b/255.0*max_color_intensity)
      end
      image = Magick::Image.new(w, h).store_pixels(0,0,w,h,pixels)
      return image.flip
    end

    def fit
      @manipulator.fit(@world_scene_graph)
    end

    def centering
      @manipulator.centering(@world_scene_graph)
    end

    def mouse_move(&block)
      @mouse_move_proc = block
    end

    def mouse_press(&block)
      @mouse_press_proc = block
    end

    def mouse_release(&block)
      @mouse_release_proc = block
    end

    def gl_display()
      GL.DrawBuffer( GL::BACK )
      GL.ClearColor(@bk_color[0],@bk_color[1],@bk_color[2],@bk_color[3])
      GL.Clear(GL::GL_COLOR_BUFFER_BIT | GL::GL_DEPTH_BUFFER_BIT)

      return if(@camera.nil? or @light.nil?)

      GL.Enable(GL::GL_DEPTH_TEST)
      @camera.set_projection_for_world_scene
      gl_display_world_scene_graph()
      GL.Disable(GL::GL_DEPTH_TEST)
      @camera.set_projection_for_camera_scene
      gl_display_camera_scene_graph()
      @compass.gl_display(self)
    end

    # users do not need to user them
    #=====================================
    def gl_display_world_scene_graph()
      return if(@world_scene_graph.nil?)
      GL.MatrixMode(GL::GL_MODELVIEW)
      GL.PushMatrix()
      GL.LoadIdentity()
      @camera.apply_position()
      @camera.apply_attitude()
      @light.gl_display()
      @world_scene_graph.gl_display(self)
      GL.PopMatrix()
    end

    def gl_display_camera_scene_graph()
      return if(@camera_scene_graph.nil?)
      GL.MatrixMode(GL::GL_MODELVIEW)
      GL.PushMatrix()
      GL.LoadIdentity()
      GLU.LookAt(0, 0, 1, 0, 0, 0, 0, 1, 0)
      @camera_scene_graph.gl_display(self)
      GL.PopMatrix()
    end

    def reshape(w,h)
      @camera.reshape(w,h)
      @compass.update
    end

    def mouse_press_process(button, x, y)
      @mouse_press_proc.call(self, button, x, y) if( @mouse_press_proc != nil)
      @manipulator.mouse(button, GLUT::GLUT_DOWN, x, y)
      @picker.mouse(button, GLUT::GLUT_DOWN, x, y)
    end

    def mouse_release_process(button, x, y)
      @mouse_release_proc.call(self, button, x, y) if( @mouse_release_proc != nil)
      @manipulator.mouse(button, GLUT::GLUT_UP, x, y)
      @picker.mouse(button, GLUT::GLUT_UP, x, y)
    end

    def mouse_move_process(x,y)
      @mouse_move_proc.call(self, x,y) if( @mouse_move_proc != nil)
      picking_in_progress = @picker.motion(x, y)
      if(picking_in_progress)
        return false
      end
      return @manipulator.motion(x, y)
    end

private
    def init_shader(vert_filename, frag_filename)
      if(!vert_filename.nil? && !frag_filename.nil?)
        vert_shader = GL.CreateShader GL_VERTEX_SHADER
        frag_shader = GL.CreateShader GL_FRAGMENT_SHADER

        File.open(vert_filename, "rb") { |file|
          GL.ShaderSource  vert_shader, file.read
          GL.CompileShader vert_shader
          success = GL.GetShaderiv   vert_shader, GL_COMPILE_STATUS
          if(success == false)
            p "failed to compile vertex shader!"
          end
        }
        File.open(frag_filename, "rb") { |file|
          GL.ShaderSource  frag_shader, file.read
          GL.CompileShader frag_shader
          success = GL.GetShaderiv   frag_shader, GL_COMPILE_STATUS
          if(success == false)
            p "failed to compile fragment shader!"
          end
        }

        @shader = GL.CreateProgram
        GL.AttachShader @shader, vert_shader
        GL.AttachShader @shader, frag_shader
        GL.LinkProgram  @shader
        GL.GetProgramiv @shader, GL_LINK_STATUS
        GL.UseProgram   @shader

        GL.DeleteShader vert_shader
        GL.DeleteShader frag_shader
      end
    end
  end
end
