class BackfillAddUuidToSleepLogs < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    SleepLog.unscoped.in_batches do |relation|
      relation.where(uuid: nil).update_all("uuid = gen_random_uuid()")
      sleep(0.01)
    end
  end
end
