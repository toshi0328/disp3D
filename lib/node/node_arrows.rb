require 'disp3D'

module Disp3D
  class NodeArrows < NodeLeaf
    attr_accessor :width

    def initialize(geom)
      super(geom)
    end

protected
    def draw_element
      if(@geom)
        GL.LineWidth(@width) if(@width)
        draw_color
        GL.Begin(GL::LINES)
        if(@geom.kind_of?(GMath3D::FiniteLine))
          draw_element_inner(@geom)
        elsif(@geom.kind_of?(Array))
          @geom.each_with_index do |line, i|
            draw_colors(i)
            draw_element_inner(line)
          end
        end
        GL.End()
      end
    end

    def draw_element_inner(line)
      start_point = line.start_point
      end_point = line.end_point

      GL.Vertex( start_point.x, start_point.y, start_point.z )
      GL.Vertex( end_point.x, end_point.y, end_point.z )

      # draw arrow head!
      head_angle = 15.0 ;
      head_ratio = 0.2 ;

      vector = line.direction
      orh = vector.arbitrary_orthogonal
      orh2 = vector.cross(orh)
      orh2 = orh2.normalize

      body_length = vector.length
      orh_length = body_length*Math.tan(head_angle*Math::PI/180.0)

      head_vec1 = Vector3.new( -vector.x + orh.x*orh_length, -vector.y + orh.y*orh_length, -vector.z + orh.z*orh_length )
      head_vec2 = Vector3.new( -vector.x + orh2.x*orh_length, -vector.y + orh2.y*orh_length, -vector.z + orh2.z*orh_length )
      head_vec3 = Vector3.new( -vector.x - orh.x*orh_length, -vector.y - orh.y*orh_length, -vector.z - orh.z*orh_length )
      head_vec4 = Vector3.new( -vector.x - orh2.x*orh_length, -vector.y - orh2.y*orh_length, -vector.z - orh2.z*orh_length )

      head_bases = Array.new(4)
      head_bases[0] = Vector3.new( end_point.x + head_vec1.x*head_ratio, end_point.y + head_vec1.y*head_ratio, end_point.z + head_vec1.z*head_ratio )
      head_bases[1] = Vector3.new( end_point.x + head_vec2.x*head_ratio, end_point.y + head_vec2.y*head_ratio, end_point.z + head_vec2.z*head_ratio )
      head_bases[2] = Vector3.new( end_point.x + head_vec3.x*head_ratio, end_point.y + head_vec3.y*head_ratio, end_point.z + head_vec3.z*head_ratio )
      head_bases[3] = Vector3.new( end_point.x + head_vec4.x*head_ratio, end_point.y + head_vec4.y*head_ratio, end_point.z + head_vec4.z*head_ratio )

      head_bases.each do | head_base |
        GL.Vertex( head_base.x, head_base.y, head_base.z )
        GL.Vertex( end_point.x, end_point.y, end_point.z )
      end

      arrow_size_minus = head_bases.size - 1
      arrow_size_minus.times do |i|
        GL.Vertex( head_bases[i  ].x, head_bases[i  ].y, head_bases[i  ].z )
        GL.Vertex( head_bases[i+1].x, head_bases[i+1].y, head_bases[i+1].z )
      end
      GL.Vertex( head_bases[arrow_size_minus].x, head_bases[arrow_size_minus].y, head_bases[arrow_size_minus].z )
      GL.Vertex( head_bases[0].x, head_bases[0].y, head_bases[0].z )
    end
  end
end
