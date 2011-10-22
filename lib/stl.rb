require 'disp3D'

module Disp3D
  class STL
    attr_reader :tris
    def initialize(triangles = nil)
      @tris = triangles
      @normals = nil
      @name = ""
    end

    def split_line(line)
      return line.strip.split(/\s+/)
    end

    def parse(file_path)
      # support only ascii type
      return false if(!FileTest.exist?(file_path))

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
        current_normal = Vector3.new( line[2].to_f, line[3].to_f, line[4].to_f )
      end
      while(line = file.gets)
        line = split_line(line)
        break if( line[0] == "endfacet" )

        if( line[0] == "outer" and line[1] == "loop")
          added = parse_outerloop_section(file)
          if( added && current_normal )
            @normals.push(current_normal)
          end
        end
      end
    end

    def parse_outerloop_section(file)
      # read vertex
      vertices = []
      while(line = file.gets )
        line = split_line(line)
        break if( line[0] == "endloop" )
        if( line[0] == "vertex")
          vertices.push(Vector3.new( line[1].to_f, line[2].to_f, line[3].to_f ))
        end
      end
      if( vertices.size >= 3)
        @tris.push(Triangle.new(vertices[0],vertices[1],vertices[2]))
        return true
      end
      return false
    end

    def tri_mesh
      return nil if(!@tris)
p @tris
      return GMath3D::TriMesh.from_triangles(@tris)
    end
  end
end
