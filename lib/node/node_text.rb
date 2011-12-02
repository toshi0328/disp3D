require 'disp3D'

module Disp3D
  class NodeText < NodeLeaf
    attr_for_disp :text
    attr_for_disp :position

    def initialize(position, name = nil, text = nil)
      Util3D.check_arg_type(Vector3, position)
      Util3D.check_arg_type(Symbol, name, true)
      Util3D.check_arg_type(String, text, true)

      super(nil, name)
      @text = text
      @position = position
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
