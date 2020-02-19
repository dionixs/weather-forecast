require 'date'

class Forecast

  TIME_OF_DAY = %w(ночь утро день вечер).freeze
  CLOUDINESS = %w[ясно малооблачно облачно пасмурно].freeze

  def initialize(params)
    @date = params[:date]
    @time_of_day = params[:time_of_day]
    @min_temp = params[:min_temp]
    @max_temp = params[:max_temp]
    @max_wind = params[:max_wind]
    @clouds = params[:clouds]
  end

  def self.get_report(node)
    day = node.attributes['day']
    month = node.attributes['month']
    year = node.attributes['year']

    new(
        date: Date.parse("#{day}.#{month}.#{year}"),
        time_of_day: TIME_OF_DAY[node.attributes['tod'].to_i],
        min_temp: node.elements['TEMPERATURE'].attributes['min'].to_i,
        max_temp: node.elements['TEMPERATURE'].attributes['max'].to_i,
        max_wind: node.elements['WIND'].attributes['max'].to_i,
        clouds: node.elements['PHENOMENA'].attributes['cloudiness'].to_i
    )
  end

  def to_s
    result = today? ? 'Сегодня' : @date.strftime('%d.%m.%Y')

    result << ", #{@time_of_day}\n" \
    "#{temperature_range_string} , ветер #{@max_wind} м/с, " \
    "#{CLOUDINESS[@clouds]}"

    result
  end

  def temperature_range_string
    result = ''
    result << '+' if @min_temp > 0
    result << "#{@min_temp}.."
    result << '+' if @max_temp > 0
    result << @max_temp.to_s
    result
  end

  def today?
    @date == Date.today
  end
end