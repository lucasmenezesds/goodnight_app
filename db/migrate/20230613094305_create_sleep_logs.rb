class CreateSleepLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :sleep_logs do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    add_index :sleep_logs, :created_at
    add_index :sleep_logs, [:user_id, :created_at], order: { created_at: :desc }, name: 'index_sleep_logs_on_user_id_and_created_at_by_desc_order'
  end
end
