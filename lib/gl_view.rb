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
    attr_reader :picker

    attr_accessor :bk_color

    def initialize(width, height)
      GL.Enable(GL::GL_DEPTH_TEST)

      GL.FrontFace(GL::GL_CW)

      GL.Enable(GL::GL_AUTO_NORMAL)
      GL.Enable(GL::GL_NORMALIZE)

      GL.Enable(GL::GL_DEPTH_TEST)
      GL.DepthFunc(GL::GL_LESS)

      GL.Enable(GL::BLEND)
      GL.BlendFunc(GL::GL_SRC_ALPHA, GL::GL_ONE_MINUS_SRC_ALPHA)

      GL.ShadeModel(GL::SMOOTH)

      @light = Light.new()
      @camera = Camera.new()
      @manipulator = Manipulator.new(@camera, width, height)
      @world_scene_graph = SceneGraph.new()
      @picker = Picker.new(self)
      @bk_color = [0.28,0.23,0.55,1]

      @mouse_move_proc = nil
    end

    def display()
      GL.ClearColor(@bk_color[0],@bk_color[1],@bk_color[2],@bk_color[3])
      GL.Clear(GL::GL_COLOR_BUFFER_BIT | GL::GL_DEPTH_BUFFER_BIT)

      @light.display() if(@light)

      @camera.display() if(@camera)
      @world_scene_graph.display() if(@world_scene_graph)
    end

    def centering
      center_pos =  @world_scene_graph.bounding_box.center * -1 # TODO refactaring vector3.rb
      @manipulator.centering(center_pos)
    end

    def fit
      centering
      length = @world_scene_graph.bounding_box.length # TODO refactaring box.rb
      orth_length = Math.sqrt( length[0]*length[0] + length[1]*length[1] + length[2]*length[2] )
      @manipulator.fit(orth_length/2.0)
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
