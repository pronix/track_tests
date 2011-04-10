require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'
require 'data/task'
require 'utils/utils'

include Swing
include Awt

class ResultPanel < JPanel
  include ActionListener

  def initialize(tour)
    super
    @tour = tour
    @textPane = createTextPane()
    add @textPane
    setLayout(BoxLayout.new(self, BoxLayout::Y_AXIS))
    setBorder(BorderFactory.createTitledBorder(@tour.translate('results')))
  end

  def actionPerformed event
    comand = event.actionCommand
    if comand == @tour.translate('start')
      @tour.startWith
    elsif comand == @tour.translate('exit')
      System.exit 0
    else
      puts 'start error tour'
      @tour.startErrorTour
    end
  end

  private

  def createTextPane
    textPane = JTextPane.new
    textPane.editable = false
    textPane.background = Color.new(0, 0, 0, 0)
    textPane.selectionColor = background
    textPane.selectedTextColor = Color::BLACK
    doc = textPane.styledDocument
    styleDef = StyleContext.getDefaultStyleContext().getStyle(StyleContext::DEFAULT_STYLE)

    regularStyle = doc.addStyle("regular", styleDef)
    StyleConstants.setFontFamily(regularStyle, "SansSerif")
    StyleConstants.setBold(regularStyle, true)
    StyleConstants.setFontSize(regularStyle, 12)

    rightStyle = doc.addStyle("right", regularStyle)
    StyleConstants.setBold(rightStyle, true)
    StyleConstants.setFontSize(rightStyle, 12)
    StyleConstants.setForeground(rightStyle, Color.new(0, 0xC0, 0))

    wrongStyle = doc.addStyle("wrong", regularStyle)
    StyleConstants.setBold(wrongStyle, true)
    StyleConstants.setFontSize(wrongStyle, 12)
    StyleConstants.setForeground(wrongStyle, Color::RED)

    # headerStyle = doc.addStyle("congrut", regularStyle)
    # StyleConstants.setFontFamily(headerStyle, "SansSerif")
    # StyleConstants.setBold(headerStyle, true)
    # StyleConstants.setFontSize(headerStyle, 20)
    # StyleConstants.setForeground(headerStyle, Color::GREEN)
    # StyleConstants.setAlignment(headerStyle, StyleConstants::ALIGN_CENTER)

    restartStyle = doc.addStyle("restart", regularStyle)
    StyleConstants.setComponent(restartStyle, createButton(@tour.translate('start')))

    checkStyle = doc.addStyle("check", regularStyle)
    StyleConstants.setComponent(checkStyle, createButton(@tour.translate('repeat')))

    exitStyle = doc.addStyle("exit", regularStyle)
    StyleConstants.setComponent(exitStyle, createButton(@tour.translate('exit')))
    begin
      doc.setLogicalStyle(doc.length, doc.getStyle("regular"))
      doc.insertString(doc.length, "#{@tour.translate('total_quest')} - #{@tour.getPassedTaskCount()} \n", doc.getStyle("regular"))
      doc.setLogicalStyle(doc.length, doc.getStyle("right"))
      doc.insertString(doc.length, "#{@tour.translate('right_quest')} - #{@tour.getRightTaskCount()} \n", doc.getStyle("right"))
      doc.setLogicalStyle(doc.length, doc.getStyle("wrong"))
      doc.insertString(doc.length, "#{@tour.translate('wrong_quest')} - #{@tour.getWrongTaskCount()} \n\n", doc.getStyle("wrong"))

      if (@tour.hasErrors)
        doc.insertString(doc.length, " ", doc.getStyle("check"))
        doc.insertString(doc.length, "\n\n", doc.getStyle("regular"))
      end
      doc.insertString(doc.length, " ", doc.getStyle("restart"))
      doc.insertString(doc.length, "\n\n", doc.getStyle("regular"))
      doc.insertString(doc.length, " ", doc.getStyle("exit"))
    rescue BadLocationException => e
    end
    textPane
  end

  def createButton title
    button = JButton.new title
    button.addActionListener(self)
    button
  end

end
