class AddPlatformToServices < ActiveRecord::Migration[6.1]
  def change
    add_column :services, :platform, :string
  end
end
