require 'Qt'

class QTWidgetController < Qt::Widget
  slots 'fit()',
        'centering()',
        'change_projection()',
        'change_color()',
        'change_alpha()'

  def initialize(gl_widget)
    super()

    @gl_widget = gl_widget
    @width = 200
    @height = 500

    setupWidgets
    setupLayout
  end

  def setupWidgets
    @info_gbox = Qt::GroupBox.new(tr("Info"))
    @vert_text = Qt::LineEdit.new(@info_gbox)
    @tris_text = Qt::LineEdit.new(@info_gbox)
    @info_gbox.layout = Qt::GridLayout.new do |m|
      m.addWidget(Qt::Label.new(tr("Vertex:")),0,0)
      m.addWidget(@vert_text,0,1)
      m.addWidget(Qt::Label.new(tr("Triangle:")),1,0)
      m.addWidget(@tris_text,1,1)
    end

    @ctrl_gbox = Qt::GroupBox.new(tr("Control"))
    @fit_btn = Qt::PushButton.new(tr("Fit"))
    @centering_btn = Qt::PushButton.new(tr("Centering"))
    @change_projection_btn = Qt::PushButton.new(tr("Projection/Orth"))
    connect(@fit_btn, SIGNAL('clicked()'), self, SLOT('fit()'))
    connect(@centering_btn, SIGNAL('clicked()'), self, SLOT('centering()'))
    connect(@change_projection_btn, SIGNAL('clicked()'), self, SLOT('change_projection()'))
    button_layout = Qt::HBoxLayout.new do |n|
      n.addWidget(@fit_btn)
      n.addWidget(@centering_btn)
    end

    @ctrl_gbox.layout = Qt::VBoxLayout.new do |m|
      m.addLayout button_layout
      m.addWidget(@change_projection_btn)
    end

    @appearance_gbox = Qt::GroupBox.new(tr("Appearance"))
    @appearance_gbox.layout = Qt::GridLayout.new do |m|
      m.addWidget(Qt::Label.new(tr("Color:")),0,0)
      m.addWidget(Qt::Label.new(tr("Hoge")),0,1)
      m.addWidget(Qt::Label.new(tr("Alpha:")),1,0)
      m.addWidget(Qt::Label.new(tr("sliderbar")),1,1)
    end
  end

  def setupLayout
    self.layout = Qt::VBoxLayout.new do |m|
      m.addWidget(@info_gbox)
      m.addWidget(@ctrl_gbox)
      m.addWidget(@appearance_gbox)
      m.addStretch()
    end
  end

  def sizeHint()
    return Qt::Size.new(@width, @height)
  end

  def fit
    @gl_widget.gl_view.fit
    @gl_widget.updateGL
  end

  def centering
    @gl_widget.gl_view.centering
    @gl_widget.updateGL
  end

  def change_projection
    if(@gl_widget.gl_view.camera.is_orth)
      @gl_widget.gl_view.camera.is_orth = false
    else
      @gl_widget.gl_view.camera.is_orth = true
    end
    @gl_widget.updateGL
  end

  def change_color
#    @document_ctrl.set_stl_color([255,0,0])
  end

  def change_alpha
  end

  def vert_cnt=(rhs)
    @vert_text.text = rhs.to_s
  end

  def tri_cnt=(rhs)
    @tris_text.text = rhs.to_s
  end
end
