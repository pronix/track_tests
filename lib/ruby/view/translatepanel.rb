require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'

require 'model/tour'

include Swing
include Awt

class TranslatePanel < JPanel
    include ActionListener

  def initialize(tour)
    super
    setLayout(BoxLayout.new(self, BoxLayout::X_AXIS))
    @tour = tour
    @translateButton = JButton.new(@tour.translate('add_trans'))
    dimension = Dimension.new(224, 30)
    @translateButton.setMinimumSize(dimension)
    @translateButton.setPreferredSize(dimension)
    @translateButton.setMaximumSize(dimension)
    @translateButton.setFocusPainted(false)

    @translateButton.addActionListener(self)
    add(@translateButton)
    setEnabled false
  end

  def actionPerformed event
    changeState (! @tour.translateEnable)
  end

  def setEnabled enabled
    @translateButton.enabled = enabled
  end

  def changeState enabled
    @tour.translateEnable = enabled
    @translateButton.text = @tour.translate(enabled ? 'hide_trans': 'add_trans')
  end

end
