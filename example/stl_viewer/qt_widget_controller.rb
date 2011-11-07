require 'Qt'

class QTWidgetController < Qt::Widget
  def initialize
    super

    @width = 200
    @height = 400

    @tab_widget = Qt::TabWidget.new()
    @tab_widget.addTab(TagPageInfo.new(), tr("Info"))
    @tab_widget.addTab(HogePage.new(), tr("Hoge"))
    @tab_widget.setSizePolicy(Qt::SizePolicy::Expanding,Qt::SizePolicy::Expanding)

    @tree_view = Qt::TreeView.new()
    @tree_view.setSizePolicy(Qt::SizePolicy::Expanding,Qt::SizePolicy::Expanding)

    self.layout = Qt::VBoxLayout.new do |m|
      m.addWidget(@tab_widget)
      m.addWidget(@tree_view)
      m.addStretch()
    end

  end

  def sizeHint()
    return Qt::Size.new(@width, @height)
  end

  ##########################################
  class TagPageInfo < Qt::Widget
    def initialize(parent=nil)
      super(parent)
      label_name = Qt::Label.new(tr("Name:"))
      label_value_name = Qt::Label.new("")
      label_value_name.frameStyle = Qt::Frame::Panel | Qt::Frame::Sunken

      label_vertex_count = Qt::Label.new(tr("Vertex Count:"))
      label_value_vertex_count = Qt::Label.new("")
      label_value_vertex_count.frameStyle = Qt::Frame::Panel | Qt::Frame::Sunken

      label_tri_count = Qt::Label.new(tr("Triangle Count:"))
      label_value_tri_count = Qt::Label.new("")
      label_value_tri_count.frameStyle = Qt::Frame::Panel | Qt::Frame::Sunken

      self.layout = Qt::GridLayout.new do |m|
        m.addWidget(label_name, 0, 0)
        m.addWidget(label_tri_count, 1, 0)
        m.addWidget(label_vertex_count, 2, 0)

        m.addWidget(label_value_name, 0, 1)
        m.addWidget(label_value_vertex_count, 1, 1)
        m.addWidget(label_value_tri_count, 2, 1)
      end
    end
  end

  class HogePage < Qt::Widget
    def initialize(parent=nil)
      super(parent)
      label = Qt::Label.new(tr("hoge"))

      self.layout = Qt::VBoxLayout.new do |m|
        m.addWidget(label)
      end
    end

  end

end
