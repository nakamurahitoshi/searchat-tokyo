json.array! @nearby_station do |station|
  if station != nil
    # 駅が取得できたら、各情報を返す
    json.id station[:stobj].id
    json.name station[:stobj].name
    json.lat station[:stobj].lat
    json.lng station[:stobj].lng
    json.dist station[:dist].round # 小数以下は四捨五入
  else
    # 取得できなかった駅の情報はnullにする
    json.id nil
    json.name nil
    json.lat nil
    json.lng nil
    json.dist nil
  end
end