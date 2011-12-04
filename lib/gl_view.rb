require 'disp3D'
require 'rmagick'

module Disp3D
  # GLView class hold primary object for 3D displaying like camera, scene_graph.
  # User never use this class
  # Use QtWidgetGL class (in Qt Application)
  # Use GLWindow class (in GLUT Window)
  class GLView
    attr_reader :world_scene_graph
    attr_reader :camera_scene_graph
    attr_reader :camera
    attr_reader :manipulator
    attr_reader :light
    attr_reader :picker

    attr_reader :mouse_move_proc
    attr_reader :mouse_press_proc
    attr_reader :mouse_release_proc

    attr_accessor :bk_color

    def initialize(width, height)
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

      @mouse_move_proc = nil
      @mouse_press_proc = nil
      @mouse_release_proc = nil
    end

    def sync_to target_view
      @world_scene_graph = target_view.world_scene_graph
    end

    def gl_display()
      GL.ClearColor(@bk_color[0],@bk_color[1],@bk_color[2],@bk_color[3])
      GL.Clear(GL::GL_COLOR_BUFFER_BIT | GL::GL_DEPTH_BUFFER_BIT)

      return if(@camera.nil? or @light.nil?)
      @light.gl_display()

      GL.Enable(GL::GL_DEPTH_TEST)
      @camera.set_projection_for_world_scene
      gl_display_world_scene_graph()
      GL.Disable(GL::GL_DEPTH_TEST)
      @camera.set_projection_for_camera_scene
      gl_display_camera_scene_graph()
      @manipulator.gl_display_compass(self)
    end

    def gl_display_world_scene_graph()
      return if(@world_scene_graph.nil?)
      GL.MatrixMode(GL::GL_MODELVIEW)
      GL.PushMatrix()
      GL.LoadIdentity()
      @camera.apply_position()
      @camera.apply_attitude()
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
  end
end
