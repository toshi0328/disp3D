require 'disp3D'

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
      @manipulator.gl_display_compass()
    end

    def gl_display_world_scene_graph()
      return if(@world_scene_graph.nil?)
      GL.MatrixMode(GL::GL_MODELVIEW)
      GL.PushMatrix()
      GL.LoadIdentity()
      @camera.apply_position()
      @camera.apply_attitude()
      @world_scene_graph.gl_display()
      GL.PopMatrix()
    end

    def gl_display_camera_scene_graph()
      return if(@camera_scene_graph.nil?)
      GL.MatrixMode(GL::GL_MODELVIEW)
      GL.PushMatrix()
      GL.LoadIdentity()
      GLU.LookAt(0, 0, 1, 0, 0, 0, 0, 1, 0)
      @camera_scene_graph.gl_display()
      GL.PopMatrix()
    end

    def capture(w, h)
      gl_display
      GL.ReadBuffer(GL::FRONT)
      GL.PixelStorei(GL::UNPACK_ALIGNMENT,1)
      data = GL.ReadPixels(0,0,w,h,GL::RGB, GL::UNSIGNED_BYTE)
      # convert to image
      #      p data.class
    end

    def set_mouse_move(proc)
      @mouse_move_proc = proc
    end

    def set_mouse_press(proc)
      @mouse_press_proc = proc
    end

    def set_mouse_release(proc)
      @mouse_release_proc = proc
    end
  end
end
