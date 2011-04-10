require 'java'
require 'module/swing'
require 'module/awt'
require 'module/lang'
require 'data/task'
require 'utils/utils'

include Swing
include Awt

class QuestPanel < JPanel
  def initialize(tour)
    super
    @tour = tour
    @textPane = createTextPane()

    scrollPane = JScrollPane.new(@textPane,
                                 ScrollPaneConstants::VERTICAL_SCROLLBAR_AS_NEEDED,
                                 ScrollPaneConstants::HORIZONTAL_SCROLLBAR_NEVER)
    scrollPane.setBorder(BorderFactory.createEmptyBorder)

    add scrollPane
    setLayout(BoxLayout.new(self, BoxLayout::Y_AXIS))

  end

  def update()
    setBorder(BorderFactory.createTitledBorder("#{@tour.translate('question')} #{@tour.taskNumber}"))
    @textPane.setText("")
    addQuestionImage(@tour.getCurrTask.image)
    drawTask(@tour.getCurrTask, false)
    if @tour.translateEnable
      drawDivider
      drawTask(@tour.translateTask, true)
    end
  end

  private

  def drawTask(task, needTranslate)
    addCompForBorder(task.question,
                     BorderFactory.createEtchedBorder(EtchedBorder::RAISED), false)

    task.variants.each_with_index do |variant, index|
      addCompForBorder("#{(?A + index).chr}. #{variant}",
                       BorderFactory.createEtchedBorder(EtchedBorder::RAISED), true)
    end
    @textPane.caretPosition = 0
  end

  def addCompForBorder(text, border, flag)
    begin
      doc = @textPane.getStyledDocument()
      styleName = flag ? "variant" : "question"
      doc.setLogicalStyle(doc.length, doc.getStyle(styleName))
      doc.insertString(doc.getLength(), "#{text}\n\n",
                       doc.getStyle(styleName))
    rescue BadLocationException => e
    end
  end

  def addQuestionImage(fileName)
    begin
      doc = @textPane.getStyledDocument()
      style = doc.getStyle("icon")
      StyleConstants.setIcon(style, loadIcon(fileName))
      doc.setLogicalStyle(doc.length, doc.getStyle("icon"))
      doc.insertString(doc.getLength(), " ", style);
      doc.insertString(doc.getLength(), "\n", doc.getStyle("question"));
    rescue Exception => e
    end
  end

  def drawDivider
    begin
      doc = @textPane.getStyledDocument()
      style = doc.getStyle("divider")
      doc.setLogicalStyle(doc.length, style)
      doc.insertString(doc.getLength(), " ", style);
      doc.setLogicalStyle(doc.length, doc.getStyle("question"))
      doc.insertString(doc.getLength(), "\n\n", doc.getStyle("question"));
    rescue Exception => e
    end
  end

  def createTextPane
    textPane = JTextPane.new
    textPane.editable = false
    textPane.background = Color.new(0, 0, 0, 0)
    textPane.selectionColor = background
    textPane.selectedTextColor = Color::BLACK
    textPane.opaque = false
    doc = textPane.styledDocument
    styleDef = StyleContext.getDefaultStyleContext().getStyle(StyleContext::DEFAULT_STYLE)

    variantStyle = doc.addStyle("variant", styleDef)
    StyleConstants.setFontFamily(styleDef, "SansSerif")
    StyleConstants.setBold(variantStyle, true)
    StyleConstants.setFontSize(variantStyle, 16)
    StyleConstants.setAlignment(variantStyle, StyleConstants::ALIGN_JUSTIFIED)

    questionStyle = doc.addStyle("question", variantStyle)
    StyleConstants.setFontSize(questionStyle, 20)

    iconStyle = doc.addStyle("icon", styleDef)
    StyleConstants.setAlignment(iconStyle, StyleConstants::ALIGN_CENTER);

    dividerStyle = doc.addStyle("divider", styleDef)
    divider = JPanel.new;
    dimension = Dimension.new(width, 1)
    divider.setMinimumSize(dimension)
    divider.setPreferredSize(dimension)
    divider.setBorder(BorderFactory.createBevelBorder(BevelBorder::RAISED))
    StyleConstants.setComponent(dividerStyle, divider)

    return textPane
  end

  private

  def loadIcon fileName
    url = Lang::ClassLoader.getSystemClassLoader().getResource(fileName)
    ImageIcon.new(javax.imageio.ImageIO.read(url))
  end
# spreeecommerce.com

end
