require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'
require 'data/task'
require 'utils/utils'
require 'view/style'

include Swing
include Awt

class AuthPanel < JPanel
  include ActionListener

  def initialize(tour)
    super
    @tour = tour
    @textField = JTextField.new
    @textPane = createTextPane()
    @timer = Timer.new(500, self)
    add @textPane
    setLayout(BoxLayout.new(self, BoxLayout::Y_AXIS))
    setBorder(BorderFactory.createTitledBorder(@tour.translate('auth')))
    @flash = 0
  end

  def actionPerformed event
    if event.source == @timer
      @flash = @flash + 1
      if (@flash > 5)
        @timer.stop
      end
      @inputButton.setBackground((@flash % 2) == 1 ? Color::RED : background)
    elsif
      if event.actionCommand == @tour.translate('input')
        if @textField.text.empty? || ! @tour.tryAuth(@textField.text, false)
          @flash = 0
          @timer.start
        end
      end
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

    textStyle = doc.addStyle("text", styleDef)
    StyleConstants.setFontSize(textStyle, 5)
    StyleConstants.setForeground(textStyle, background)

    regularStyle = doc.addStyle("regular", styleDef)
    StyleConstants.setFontFamily(regularStyle, "SansSerif")
    StyleConstants.setBold(regularStyle, true)
    StyleConstants.setFontSize(regularStyle, 16)

    inputStyle = doc.addStyle("input", regularStyle)
    StyleConstants.setComponent(inputStyle, @textField)

    restartStyle = doc.addStyle("okButton", regularStyle)
    @inputButton = createButton(@tour.translate('input'))
    StyleConstants.setComponent(restartStyle, @inputButton)
    # StyleConstants.setAlignment(restartStyle, StyleConstants::ALIGN_CENTER)


    begin
      doc.insertString(doc.length, "#{@tour.translate('input_key')}: \n", doc.getStyle("regular"))
      doc.insertString(doc.length, " ", doc.getStyle("input"))
      doc.setLogicalStyle(doc.length, doc.getStyle("text"))
      doc.insertString(doc.length, "\na\n", doc.getStyle("text"))
      doc.setLogicalStyle(doc.length, doc.getStyle("okButton"))
      doc.insertString(doc.length, " ", doc.getStyle("okButton"))
      
    rescue BadLocationException => e
    end
    textPane
  end

  def createButton title
    button = JButton.new title
    button.addActionListener(self)
    button.setFocusPainted(false)
    button.setFont(Font.new("SansSerif", Font::BOLD, 16))
    Style.button button
    dimension = Dimension.new(button.preferredSize.width + 40, button.preferredSize.height + 4)
    button.preferredSize = dimension
    button.minimumSize = dimension
    button
  end

end
