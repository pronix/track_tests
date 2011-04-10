require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'
require 'data/task'
require 'utils/utils'
require 'view/numberfilter'

include Swing
include Awt

class StartPanel < JPanel
  include ActionListener

  def initialize(tour)
    super
    @tour = tour
    @textField = createNumberInput 1
    @textPane = createTextPane()
    add @textPane
    setLayout(BoxLayout.new(self, BoxLayout::Y_AXIS))
    setBorder(BorderFactory.createTitledBorder(@tour.translate('start_with')))
  end

  def actionPerformed event
    if event.actionCommand == @tour.translate('input')
      value = @textField.text.to_i
      @tour.start @textField.text.to_i - 1
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
    StyleConstants.setFontSize(regularStyle, 16)

    inputStyle = doc.addStyle("input", regularStyle)
    StyleConstants.setComponent(inputStyle, @textField)

    restartStyle = doc.addStyle("okButton", regularStyle)
    StyleConstants.setComponent(restartStyle, createButton(@tour.translate('input')))
    begin
      doc.setLogicalStyle(doc.length, doc.getStyle("text"))
      doc.insertString(doc.length, "#{@tour.translate('start_quest_number')} (1-#{@tour.taskCount}):\n", doc.getStyle("regular"))
      doc.insertString(doc.length, " ", doc.getStyle("input"))
      doc.insertString(doc.length, "\n", doc.getStyle("regular"))
      doc.insertString(doc.length, " ", doc.getStyle("okButton"))
    rescue BadLocationException => e
    end
    textPane
  end

  def createButton title
    button = JButton.new title
    button.addActionListener(self)
    button
  end

  def createNumberInput init
    textField = JTextField.new
    textField.document = NumberFilter.new(textField, 1, @tour.taskCount)
    textField.text = init.to_s
    textField
  end

end
