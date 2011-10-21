require 'disp3D'

module Disp3D
  class SceneGraph
    attr_accessor :root_node
    MAT_DIFFUSE   = [1.0, 1.0, 1.0]
    MAT_AMBIENT   = [0.25, 0.25, 0.25]
    MAT_SPECULAR  = [1.0, 1.0, 1.0]
    MAT_SHININESS = [32.0]

    def initialize()
      @root_node = NodeCollection.new()
    end

    def display()
      GL.Materialfv(GL::GL_FRONT, GL::GL_DIFFUSE, MAT_DIFFUSE)
      GL.Materialfv(GL::GL_FRONT, GL::GL_AMBIENT, MAT_AMBIENT)
      GL.Materialfv(GL::GL_FRONT, GL::GL_SPECULAR, MAT_SPECULAR)
      GL.Materialfv(GL::GL_FRONT, GL::GL_SHININESS, MAT_SHININESS)
      @root_node.draw()
    end

    def add(node)
      @root_node.add(node)
    end
  end
end
