json.array! @stations do |station|
  json.id station.id
  json.name station.name
  json.lat station.lat
  json.lng station.lng
end