require 'disp3D'

module Disp3D
  class NodeRectangle < NodeLeaf
    # texture_image should be rmagick image
    def initialize(geom, name = nil)
      Util3D.check_arg_type(Symbol, name, true)
      Util3D.check_arg_type(GMath3D::Rectangle, geom, false, false) #Array is not allowed
      super
    end

    def box
      return @geom.box
    end

    def image=(texture_image)
      Util3D.check_arg_type(Magick::Image, texture_image, true)
      @image = texture_image
      initialize_texture
      update_for_display
    end

protected
    def draw_element
      if(@geom && @geom.kind_of?(GMath3D::Rectangle))
        draw_color
        GL::BindTexture(GL::TEXTURE_2D, @texture[0]) if(!@texture.nil?)

        GL.Enable(GL::TEXTURE_2D) if(!@texture.nil?)
        GL.Begin(GL::QUADS)
        GL.Normal(@geom.normal.x, @geom.normal.y, @geom.normal.z)
        vertices = @geom.vertices

        GL.TexCoord2d(0.0, 1.0) if(!@texture.nil?)
        GL.Vertex( vertices[0].x, vertices[0].y, vertices[0].z )
        GL.TexCoord2d(1.0, 1.0) if(!@texture.nil?)
        GL.Vertex( vertices[1].x, vertices[1].y, vertices[1].z )
        GL.TexCoord2d(1.0, 0.0) if(!@texture.nil?)
        GL.Vertex( vertices[2].x, vertices[2].y, vertices[2].z )
        GL.TexCoord2d(0.0, 0.0) if(!@texture.nil?)
        GL.Vertex( vertices[3].x, vertices[3].y, vertices[3].z )

        GL.End()
        GL.Disable(GL::TEXTURE_2D) if(!@texture.nil?)
      else
        raise
      end
    end

private
    def initialize_texture
      if(!@image.nil?)
        data_ary = @image.to_array
        data = data_ary.pack("f*")

        GL::PixelStore(GL::UNPACK_ALIGNMENT,1)
        @texture = GL::GenTextures(1)
        GL::BindTexture(GL::TEXTURE_2D, @texture[0])
        GL::TexParameter(GL::TEXTURE_2D, GL::TEXTURE_MAG_FILTER, GL::LINEAR)
        GL::TexParameter(GL::TEXTURE_2D, GL::TEXTURE_MIN_FILTER, GL::LINEAR)
        GL::TexImage2D(
            GL::TEXTURE_2D,
            0,
            GL::RGB8,
            @image.columns, @image.rows,
            0,
            GL::RGB,
            GL::FLOAT,
            data )
      end
    end

  end
end
