require 'stl_viewer'

class DocumentCtrl
  attr_reader :document

  def initialize(main_window)
    @document = nil # this is THE ROOT DOCUMENT of this application
    @main_window = main_window
    @gl_ctrl = GLCtrl.new(main_window.gl_widget)
  end

  def new
    if (@document.nil? || may_be_save)
      @document = Document.new()
    end
  end

  def open
    #TODO implement!
  end

  def save
    #TODO implement! return true if success
    return true
  end

  def add_stl
    if(@document.nil?)
      new()
    end

    file_name = Qt::FileDialog.getOpenFileName(@main_window)
    if !file_name.nil?
      stl = STL.new()
      if stl.parse(file_name)
        added =  @document.add_tri_mesh!(stl.tri_mesh)
        if !added.nil?
          @gl_ctrl.add2scenegraph(added)
        end
      end
    end
  end

private
  def may_be_save
    if @document.dirty
      ret = Qt::MessageBox::warning(@main_window, tr("STL Viewer"),
                            tr("The document has been modified. \n" +
                               "Do you want to save your change?"),
                            Qt::MessageBox::Yes | Qt::MessageBox::Defaut,
                            Qt::MessageBox::No,
                            Qt::MessageBox::Cancel | Qt::MessageBox::Escape)
      if ret == Qt::MessageBox::Yes
        return save()
      elsif ret == Qt::MessageBox::Cancel
        return false
      end
    end
    return true
  end

end
