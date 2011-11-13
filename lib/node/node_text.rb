require 'disp3D'

module Disp3D
  class NodeText < NodeLeaf
    attr_accessor :text
    attr_accessor :position

    def initialize(text, position)
      @text = text
      @position = position
      super(nil)
    end

protected
    def draw_element
      if(@text and @position)
        draw_color
        GL.RasterPos(@position.x, @position.y, @position.z)
        @text.bytes.to_a.each do |ascii|
          GLUT.BitmapCharacter(GLUT::BITMAP_HELVETICA_18, ascii)
        end
      end
    end
  end
end
