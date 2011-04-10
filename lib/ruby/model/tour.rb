require 'java'
require 'data/task'
require 'utils/prefs'
require 'data/i18n'

class Tour
  def initialize(i18n, filename)
    langs = i18n.langList
    @fullTaskList = load(filename, langs[0])

    @translateTaskList = nil
    @translateEnable = false
    if (langs.length == 2)
      @translateTaskList = load(filename, langs[1])
    end
      
    @taskList = @fullTaskList
    @currTask = nil
    @wrongTask = 0
    @rightTask = 0
    @prefs = Preference.new
    @errorTaskList = []

    @i18n = i18n
  end

  def nextTask
    if @lastResult
      @rightTask += 1
    else
      @errorTaskList = @errorTaskList << (@currTask.number - 1)
      @wrongTask += 1
    end
    @lastResult = true
    @currTaskIndex += 1

    if @currTaskIndex < @taskList.length
      @currTask = @taskList[@currTaskIndex]
      @container.update
    else
      @container.update
      result
    end
    @currTask
  end

  def container= container
    @container = container
  end

  def getPassedTaskCount
    @rightTask + @wrongTask
  end

  def getRightTaskCount
    @rightTask
  end

  def getWrongTaskCount
    @wrongTask
  end

  def getCurrTask
    @currTask
  end

  def getVariantCount
    @currTask.variants.length
  end

  def getRightVariant
    @currTask.right
  end

  def setBadResult
    @lastResult = false
  end

  def lastResult
    @lastResult
  end

  def checkAndStart
    if is_auth
      startWith
    else
      @container.showAuth
    end
  end

  def tryAuth(key, isSkip)
    result = false
    resList = com.pronix.knowledge.Launch.check(key.gsub('-', ''))
    if resList != nil && @prefs.newKey?(key)
      @prefs.set_auth(key, resList)
      if @prefs.is_auth
        result = true
        startWith
      end
    end
    result
  end

  def start index
    @taskList = @fullTaskList
    @currTaskIndex = index
    @wrongTask = 0
    @rightTask = 0
    @currTask = @taskList[index]
    @lastResult = true
    @errorTaskList = []

    @container.startTour
  end

  def startErrorTour
    @currTaskIndex = @wrongTask = @rightTask = 0
    @lastResult = true

    @taskList = []
    @errorTaskList.each do |index|
      @taskList = @taskList << @fullTaskList[index]
    end
    @currTask = @taskList[@currTaskIndex]
    @errorTaskList = []

    @container.startTour
  end

  def result
    @container.showResult
  end

  def preferences
    @prefs
  end

  def is_auth
    @prefs.is_auth
  end

  def taskCount 
    @taskList.length
  end

  def startWith
    @wrongTask = @rightTask = 0
    @taskList = @fullTaskList
    @errorTaskList = []
    @container.showStartWith
  end

  def taskNumber
    @currTask.number
  end

  def isTrialDate
    @prefs.checkRun && @prefs.isDateValid
  end

  def hasErrors
    @errorTaskList.length != 0
  end

  def translate(key, lang)
    @i18n.get(key, lang)
  end

  def translate(key)
    @i18n.default(key)
  end

  def translateTaskExists
    @translateTaskList != nil
  end

  def translateEnable= enable
    if translateTaskExists
      @translateEnable = enable
      @container.update
    end
  end

  def translateEnable
    @translateEnable
  end

  def translateTask
    @translateTaskList[@currTask.number - 1]
  end

  private

  def load (filename, lang)
    YAML::load(File.open("../../res/#{filename}_#{lang}.yml"))
  end

end  

