require 'csv'

p 'csvファイルの、appより下のパスを指定してください'
path = gets.gsub(/[\r\n]/,"")
table = CSV.read(path)

p '路線名を入力してください'
train_line_name = gets.gsub(/[\r\n]/,"")
if !TrainLine.exists?(name: train_line_name)
  p "路線名 #{train_line_name} が存在しないので作成します、よろしいですか？(y)"
  if gets.gsub(/[\r\n]/,"") == 'y'
    train_line_id = TrainLine.create!(name: train_line_name).id
  else
    exit
  end
else
  train_line_id = TrainLine.find_by(name: train_line_name).id
end

p '出発駅は「終点を除く全ての駅」ですか？(y/n)'
start_all = gets.gsub(/[\r\n]/,"")
if start_all == 'y'
  start_stations = table[0] - [table[0][-1]]
elsif start_all == 'n'
  p '出発駅を空白区切りで入力してください'
  start_stations = gets.gsub(/[\r\n]/,"").split(' ')
else
  exit
end

p '到着駅は「始点を除く全ての駅」ですか？(y/n)'
reach_all = gets.gsub(/[\r\n]/,"")
if reach_all == 'y'
  reach_stations = table[0] - [table[0][0]]
elsif reach_all == 'n'
  p '到着駅を空白区切りで入力してください'
  reach_stations = gets.gsub(/[\r\n]/,"").split(' ')
else
  exit
end

p '荷物置き場はありますか？(y/n)'
input_laggage_space = gets.gsub(/[\r\n]/,"")
if input_laggage_space == 'y'
  has_laggage_space = true
elsif input_laggage_space == 'n'
  has_laggage_space = false
else
  exit
end

# ヘッダーの日本語→ヘッダー内でのインデックス、となるハッシュを作成
station_name2index = {}
table[0].each_with_index do |station_name, i|
  station_name2index[station_name] = i
end

(1...table.size).each do |i|
  p '========'
  p 'i', i
  row = table[i]
  start_stations.each do |start_station_name|
    start_station_id = Station.find_or_create_by!(name: start_station_name).id
    time_match = /(.*):(.*)/.match(row[station_name2index[start_station_name]])
    if time_match.present?
      start_hour, start_minute = time_match.values_at(1,2).map(&:to_i)
    else
      next
    end
    reach_stations.each do |reach_station_name|
      reach_station_id = Station.find_or_create_by!(name: reach_station_name).id
      time_match = /(.*):(.*)/.match(row[station_name2index[reach_station_name]])
      if time_match.present?
        reach_hour, reach_minute = time_match.values_at(1,2).map(&:to_i)
      else
        next
      end
      transport_id = Transport.find_or_create_by!(start_station_id: start_station_id, reach_station_id: reach_station_id, train_line_id: train_line_id).id
      service = Service.find_or_create_by!(transport_id: transport_id, start_hour: start_hour, start_minute: start_minute, reach_hour: reach_hour, reach_minute: reach_minute, is_with_laggage_space: has_laggage_space)
      p service
    end
  end
end
