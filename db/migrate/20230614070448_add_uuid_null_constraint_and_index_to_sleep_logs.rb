class AddUuidNullConstraintAndIndexToSleepLogs < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    change_column_null(:sleep_logs, :uuid, false)
    add_index :sleep_logs, :uuid, unique: true, algorithm: :concurrently
  end
end
