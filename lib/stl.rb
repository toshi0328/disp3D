require 'disp3D'

module Disp3D
  class STL
    attr_reader :tris
    attr_reader :normals
    attr_reader :name

    ASCII = 0
    BINARY = 1

    def initialize(triangles = nil)
      @tris = triangles
      @normals = nil
      @name = ""
    end

    # return true if success processing.
    def parse(file_path, type =BINARY )
      return false if(!FileTest.exist?(file_path))

      if(type == ASCII)
        return parse_ascii(file_path)
      elsif(type == BINARY)
        return parse_binary(file_path)
      end
      @tris = nil
      return false
    end

    def tri_mesh
      return nil if(!@tris)
      return GMath3D::TriMesh.from_triangles(@tris)
    end

private
    def parse_binary(file_path)
      @tris = Array.new()
      @normals = Array.new()
      file_ptr = open(file_path, "r")
      file_ptr.binmode
      buf = file_ptr.read(80)
      buf = file_ptr.read(4)
      tri_count = buf.unpack("i*")[0]
      @tris = Array.new(tri_count)
      @normals = Array.new(tri_count)
      tri_count.times do | idx |
        buf = file_ptr.read(12*4)
        numeric = buf.unpack("f*")
        @normals[idx] = Vector3.new(numeric[0], numeric[1], numeric[2])
        adding_triangle = GMath3D::Triangle.new(
                                            Vector3.new(numeric[3], numeric[4], numeric[5]),
                                            Vector3.new(numeric[6], numeric[7], numeric[8]),
                                            Vector3.new(numeric[9], numeric[10], numeric[11]))
        @tris[idx] = adding_triangle
        file_ptr.read(2) # spacer
      end
      return true
    end

    def parse_ascii(file_path)
      @tris = Array.new()
      @normals = Array.new()

      open(file_path, "r"){|file|
        while(line = file.gets)
          line = split_line(line)
          if(line[0] == "solid")
            @name = line[1]
            parse_solid_section(file)
          end
        end
      }
      @normals = nil if( @normals.size == 0 )
      return true
    end

    def split_line(line)
      return line.strip.split(/\s+/)
    end

    def parse_solid_section(file)
      while(line = file.gets)
        line = split_line(line)
        # read facet
        if(line[0] == "facet")
          parse_facet_section(file,line)
        end
      end
    end

    def parse_facet_section(file, line)
      current_normal = nil
      if(line[1] == "normal")
        current_normal = GMath3D::Vector3.new( line[2].to_f, line[3].to_f, line[4].to_f )
      end
      while(line = file.gets)
        line = split_line(line)
        break if( line[0] == "endfacet" )

        if( line[0] == "outer" and line[1] == "loop")
          added_triangle = parse_outerloop_section(file, current_normal)
        end
      end
    end

    def parse_outerloop_section(file, current_normal)
      # read vertex
      vertices = []
      while(line = file.gets )
        line = split_line(line)
        break if( line[0] == "endloop" )
        if( line[0] == "vertex")
          vertices.push(GMath3D::Vector3.new( line[1].to_f, line[2].to_f, line[3].to_f ))
        end
      end
      if( vertices.size >= 3)
        adding_triangle = GMath3D::Triangle.new(vertices[0],vertices[1],vertices[2])
        if( current_normal != nil )
          if(adding_triangle.normal.dot(current_normal) < 0)
            adding_triangle = adding_triangle.reverse()
          end
          @normals.push(current_normal)
        end
        @tris.push(adding_triangle)
        return adding_triangle
      end
      return nil
    end
  end
end
