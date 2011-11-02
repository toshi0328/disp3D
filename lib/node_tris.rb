require 'disp3D'

module Disp3D
  class NodeTris < NodeLeaf

protected
    def draw_element
      if(@geom)
        GL.ShadeModel(GL::SMOOTH)
        GL.Begin(GL::TRIANGLES)
        if(@geom.kind_of?(GMath3D::TriMesh))
          @geom.triangles.each do |tri_geom|
            GL.Normal(tri_geom.normal.x, tri_geom.normal.y, tri_geom.normal.z)
            tri_geom.vertices.each do |vertex|
              GL.Vertex( vertex.x, vertex.y, vertex.z )
            end
          end
        end
        GL.End()
      end
    end

  end
end
