class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.string :name, null: false
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :users, :deleted_at
  end
end
