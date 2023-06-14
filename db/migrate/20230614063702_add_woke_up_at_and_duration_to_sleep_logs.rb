class AddWokeUpAtAndDurationToSleepLogs < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_column :sleep_logs, :woke_up_at, :timestamp, default: nil, precision: 6
    add_column :sleep_logs, :duration, :time, default: nil

    add_index :sleep_logs, [:user_id, :duration], order: { duration: :desc }, name: 'index_sleep_logs_on_user_id_and_duration_by_desc_order', algorithm: :concurrently
  end
end
