require 'disp3D'

module Disp3D
  class View
    attr_accessor :world_scene_graph
    attr_accessor :camera

    attr_accessor :bk_color

    def display()
      GL.ClearColor(@bk_color[0],@bk_color[1],@bk_color[2],@bk_color[3])

      @camera.display() if(@camera)
      @world_scene_graph.display() if(@world_scene_graph)
      GLUT.SwapBuffers()
    end

    def initialize(x,y,width,height)
      GLUT.InitWindowPosition(x, y)
      GLUT.InitWindowSize(width, height)
      GLUT.Init
      GLUT.InitDisplayMode(GLUT::GLUT_DOUBLE | GLUT::GLUT_RGB | GLUT::GLUT_DEPTH)
      GLUT.CreateWindow("Disp3D view test")

      GL.Enable(GL::GL_DEPTH_TEST)

      GL.FrontFace(GL::GL_CW)
      GL.Enable(GL::GL_AUTO_NORMAL)
      GL.Enable(GL::GL_NORMALIZE)
      GL.Enable(GL::GL_DEPTH_TEST)
      GL.DepthFunc(GL::GL_LESS)
      GL.ShadeModel(GL::SMOOTH)

      GLUT.DisplayFunc(method(:display).to_proc())

      @camera = Camera.new()
      @manipulator = Manipulator.new(@camera)
      @world_scene_graph = SceneGraph.new()

      @bk_color = [0.5,0.5,0.5,0]
   end

    def start
      GLUT.MainLoop()
    end
  end
end
