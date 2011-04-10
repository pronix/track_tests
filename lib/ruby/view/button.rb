require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'
require 'data/task'
require 'view/style'

include Swing
include Awt

class Button < JButton
  include ActionListener

  def initialize(title)
    super(title)
    @timer = Timer.new(500, self)
    @defaultBorder = getBorder()
    @defaultColor = getBackground()
    @borderEnabled = false
    dimension = Dimension.new(120, 50)
    setMinimumSize(dimension)
    setPreferredSize(dimension)
    setFont(Font.new("SansSerif", Font::BOLD, 25))
    setFocusPainted(false)
    Style.button self

  end
              
  def actionPerformed(event)
    if event.source == @timer
      setBlinkMode(@borderEnabled)
    end
  end

  def startBlinking
    setBlinkMode(true)
    @timer.start
  end

  def stopBlinking
    @timer.stop
    # setBorder(@defaultBorder)
    setBackground(@defaultColor)
  end

  private

  def setBlinkMode(flag)
    setBackground(flag ? Color::GREEN : @defaultColor)
    @borderEnabled = ! flag
  end

end
