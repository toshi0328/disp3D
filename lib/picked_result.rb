require 'disp3D'

module Disp3D
  class PickedResult
    attr_reader :near
    attr_reader :far
    attr_reader :nodes

    def initialize(near, far, nodes)
      @near = near
      @far = far
      @nodes = nodes
    end
  end
end
