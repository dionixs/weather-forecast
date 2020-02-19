# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'rexml/document'

require_relative 'lib/forecast'

CITIES = {
    7989  => 'Москва',
    69 => 'Санкт-Петербург',
    87 => 'Тверь',
    21 => 'Хабаровск',
    140 => 'Уфа',
    31216 => 'Рязань',
    2873 => 'Ростов'
}.invert.freeze

city_names = CITIES.keys

puts "Погоду для какого города Вы хотите узнать?"
city_names.each_with_index { |item, index| puts "#{index + 1}: #{item}" }
print "> "
city_index = STDIN.gets.to_i

city_id = CITIES[city_names[city_index - 1]] if CITIES.has_key? CITIES[city_names[city_index - 1]]
city_id = city_index unless CITIES.has_key? CITIES[city_names[city_index - 1]]

uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{city_id}.xml")
response = Net::HTTP.get_response(uri)
doc = REXML::Document.new(response.body)

city_name = URI.decode_www_form(
    doc.root.elements['REPORT/TOWN'].attributes['sname']
)

reports = doc.root.elements['REPORT/TOWN'].elements.to_a

puts
puts city_name

reports.each do |node|
  puts Forecast.get_report(node)
  puts
end