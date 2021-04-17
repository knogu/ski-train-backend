station_id = Station.find_or_create_by!(name:'東京').id
train_line_1_id = TrainLine.find_or_create_by!(name:'マイタウンダイレクトバス 新浦安線').id
train_line_2_id = TrainLine.find_or_create_by!(name:'上越新幹線').id
train_line_1_id, train_line_2_id = [train_line_1_id, train_line_2_id].minmax
Transfer.find_or_create_by!(station_id: station_id, train_line_1_id: train_line_1_id, train_line_2_id: train_line_2_id, default_minute: 12)

station_id = Station.find_or_create_by!(name:'越後湯沢').id
train_line_1_id = TrainLine.find_or_create_by!(name:'上越新幹線').id
train_line_2_id = TrainLine.find_or_create_by!(name:'神立スノーリゾート シャトルバス').id
train_line_1_id, train_line_2_id = [train_line_1_id, train_line_2_id].minmax
Transfer.find_or_create_by!(station_id: station_id, train_line_1_id: train_line_1_id, train_line_2_id: train_line_2_id, default_minute: 7)
