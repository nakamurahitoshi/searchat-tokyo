json.body       @message.body
json.user_name  @message.user.name
json.created_at @message.created_at.strftime("%Y/%m/%d %H:%M")
json.id         @message.id
json.user_id    @message.user.id
json.station_id @station.id