require 'java'

class Preference
  START_DATE_KEY = "data"
  AUTH_KEY = "auth"
  DAYS_KEY = "days"
  ARCHIVE_KEY = "arhive" 

  Calendar = java.util.Calendar

  def initialize
    @prefs = java.util.prefs.Preferences.userRoot().node('com.pronix.knowledge')
    # puts "init archive: #{@prefs.get(ARCHIVE_KEY, "no found")}"
  end

  def is_auth
    @prefs.get(AUTH_KEY, '') != '' && isDateValid
  end

  def set_auth (key, authDataList)
    @prefs.put(AUTH_KEY, key)
    archiveKey(key)
    @prefs.putLong(START_DATE_KEY, authDataList.get(0).getTime)
    @prefs.putLong(DAYS_KEY, authDataList.get(1))
    @prefs.flush
    @prefs.sync
  end

  def isDateValid
    date = lastDay
    date > 0 && date <= days
  end

  def lastDay
    days - Utils.diff_date(date, Calendar.instance)
  end

  def newKey? key
    str = @prefs.get(ARCHIVE_KEY, "")
    not str.split(',').include?(Utils.crc32(key).to_s)
  end

  private

  def days
    @prefs.getLong(DAYS_KEY, 30)
  end

  def date
    calendar = Calendar.instance
    millis = @prefs.getLong(START_DATE_KEY, 0)
    calendar.timeInMillis = millis
    calendar
  end

  def archiveKey key
    str = @prefs.get(ARCHIVE_KEY, "")
    sum = Utils.crc32(key).to_s
    str = str.empty? ? sum : "#{str},#{sum}"
    @prefs.put(ARCHIVE_KEY, str)
    
    # puts "update archive: #{@prefs.get(ARCHIVE_KEY, "no found")}"
  end
end
