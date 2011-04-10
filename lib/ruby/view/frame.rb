require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'
require 'model/tour'

require 'view/tour'

include Swing
include Awt

class MainFrame < JPanel
  def initialize tour
    super BorderLayout.new(0,1)
    @tour = tour
    setBorder(BorderFactory.createEmptyBorder(10,10,10,10))
    @tourpanel = TourPanel.new(self, @tour)
    @tour.checkAndStart
  end

  def setTourPanel
    removeAll
    add(@tourpanel, BorderLayout::CENTER)
    repaint
  end

  def setResultPanel
    removeAll
    add(ResultPanel.new(@tour), BorderLayout::CENTER)
    invalidate
  end

end
