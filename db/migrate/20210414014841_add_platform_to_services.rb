class AddPlatformToServices < ActiveRecord::Migration[6.1]
  def change
    add_column :services, :platform, :string, comment: '出発ホーム(番線)'
  end
end
