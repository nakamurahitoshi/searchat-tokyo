# お気に入り解除時
if @favorite_station == nil
  json.id nil
  json.name nil
  json.lat nil
  json.lng nil

# お気に入り登録時
else
  json.id @favorite_station.id
  json.name @favorite_station.name
  json.lat @favorite_station.lat
  json.lng @favorite_station.lng
end