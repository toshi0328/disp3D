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

    attr_accessor :bk_color

    LIGHT_POSITION = [0.25, 1.0, 0.25, 0.0]
    LIGHT_DIFFUSE  = [1.0, 1.0, 1.0]
    LIGHT_AMBIENT  = [0.25,0.25,0.5]
    LIGHT_SPECULAR = [1, 1, 1]

    def display()
      GL.ClearColor(@bk_color[0],@bk_color[1],@bk_color[2],@bk_color[3])

#TODO create lighting object!
      GL.Lightfv(GL::GL_LIGHT0, GL::GL_POSITION, LIGHT_POSITION)
      GL.Lightfv(GL::GL_LIGHT0, GL::GL_DIFFUSE, LIGHT_DIFFUSE)
      GL.Lightfv(GL::GL_LIGHT0, GL::GL_AMBIENT, LIGHT_AMBIENT)
      GL.Lightfv(GL::GL_LIGHT0, GL::GL_SPECULAR, LIGHT_SPECULAR)

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

      @camera = Camera.new()
      @manipulator = Manipulator.new(@camera, width, height)
      @world_scene_graph = SceneGraph.new()

      @bk_color = [0.5,0.5,0.5,0]
   end
  end
end
