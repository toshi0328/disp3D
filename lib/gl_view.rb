require 'disp3D'

module Disp3D
  # GLView class hold primary object for 3D displaying like camera, scene_graph.
  # User never use this class
  # Use QtWidgetGL class (in Qt Application)
  # Use GLWindow class (in GLUT Window)
  class GLView
    attr_reader :world_scene_graph
    attr_reader :camera
    attr_reader :manipulator
    attr_reader :light

    attr_accessor :bk_color

    def display()
      GL.ClearColor(@bk_color[0],@bk_color[1],@bk_color[2],@bk_color[3])

      @light.display() if(@light)
      @camera.display() if(@camera)
      @world_scene_graph.display() if(@world_scene_graph)
    end

    def initialize(width, height)
      GL.Enable(GL::GL_DEPTH_TEST)

      GL.FrontFace(GL::GL_CW)

      GL.Enable(GL::GL_AUTO_NORMAL)
      GL.Enable(GL::GL_NORMALIZE)

      GL.Enable(GL::GL_DEPTH_TEST)
      GL.DepthFunc(GL::GL_LESS)

      GL.ShadeModel(GL::SMOOTH)

      @light = Light.new()
      @camera = Camera.new()
      @manipulator = Manipulator.new(@camera, width, height)
      @world_scene_graph = SceneGraph.new()

      @bk_color = [0.28,0.23,0.55,1]
   end
  end
end
