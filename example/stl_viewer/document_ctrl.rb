# -*- coding: utf-8 -*-
require 'observer'

require 'Qt'
require 'stl_viewer'

class DocumentCtrl
  attr_reader :document

  def initialize(main_window)
    @document = nil # this is THE ROOT DOCUMENT of this application
    @main_window = main_window
  end

  def open
    return if(!exit_current_session?)
    file_name = Qt::FileDialog.getOpenFileName(@main_window)
    if !file_name.nil?
      stl = Disp3D::STL.new()
      if stl.parse(file_name, Disp3D::STL::ASCII)
        @document = Document.new()
        @document.add_observer(self)
        @document.tri_mesh = stl.tri_mesh
      end
    end
  end

# 更新といっても、ノードの入れ替え、色の変更、フィットさせるだけなど、様々と思うが・・・
  def update
    @main_window.gl_widget.gl_view.world_scene_graph.add(@document.tri_node)
    @main_window.gl_widget.gl_view.fit
    @main_window.gl_widget.updateGL

    @main_window.ctrl_widget.vert_cnt = @document.tri_mesh.vertices.size
    @main_window.ctrl_widget.tri_cnt = @document.tri_mesh.tri_indices.size
  end

private
  def exit_current_session?
    if !@document.nil?
      ret = Qt::MessageBox::warning(@main_window, tr("STL Viewer"),
                            tr("Already STL file is open. \n" +
                               "Do you want to exit current session?"),
                            Qt::MessageBox::Yes | Qt::MessageBox::Defaut,
                            Qt::MessageBox::No| Qt::MessageBox::Escape )
      if ret == Qt::MessageBox::Yes
        return true
      elsif ret == Qt::MessageBox::No
        return false
      end
    end
    return true
  end

end
