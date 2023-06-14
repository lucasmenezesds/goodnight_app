class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.references :source, type: :uuid, null: false, index: true, foreign_key: { to_table: :users }
      t.references :target, type: :uuid, null: false, index: true, foreign_key: { to_table: :users }
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :relationships, :deleted_at
    add_index :relationships, [:source_id, :target_id], unique: true
  end
end
