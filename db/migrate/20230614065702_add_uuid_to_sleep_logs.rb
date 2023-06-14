class AddUuidToSleepLogs < ActiveRecord::Migration[6.1]

  def up
    add_column :sleep_logs, :uuid, :uuid
    change_column_default :sleep_logs, :uuid, "gen_random_uuid()"
  end

  def down
    remove_column :sleep_logs, :uuid
  end
end
