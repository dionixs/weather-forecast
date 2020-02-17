require 'net/http'
require 'uri'
require 'rexml/document'

CLOUDINESS = %w(Ясно Малооблачно Облачно Пасмурно).freeze

uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/87.xml")
response = Net::HTTP.get_response(uri)
doc = REXML::Document.new(response.body)

city_name = URI.decode_www_form(
    doc.root.elements['REPORT/TOWN'].attributes['sname']
)

time = Time.now

current_forecast = doc.root.elements['REPORT/TOWN'].elements.to_a[0]

min_temp = current_forecast.elements['TEMPERATURE'].attributes['min']
max_temp = current_forecast.elements['TEMPERATURE'].attributes['max']

max_wind = current_forecast.elements['WIND'].attributes['max']

clouds_index = current_forecast.elements['PHENOMENA'].attributes['cloudiness'].to_i
clouds = CLOUDINESS[clouds_index]

puts city_name[0][0]
puts time
puts "Температура: от #{min_temp}°C до #{max_temp}°C"
puts "Ветер до #{max_wind} m/s"
puts clouds