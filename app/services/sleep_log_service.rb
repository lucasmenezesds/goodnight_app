# frozen_string_literal: true

module SleepLogService
  def self.log_sleep_data(user)
    last_sleep_log = user.sleep_logs.last

    if last_sleep_log.nil? || last_sleep_log.woke_up_at.present?
      user.sleep_logs.new
    else
      last_sleep_log.woke_up_at = Time.zone.now
      last_sleep_log
    end
  end

  def self.logs_from_people_user_is_following(user)
    SleepLog.joins(user: :followed_relationships)
            .where(followed_relationships: { source_id: user.id })
            .where(sleep_logs: { created_at: 1.week.ago.all_week })
            .order(duration: :desc)
  end

  def self.logs_from_followers(user)
    # Different approach, but this approach does two queries instead of one.
    SleepLog.where(user_id: user.followers.pluck(:id))
            .where(sleep_logs: { created_at: 1.week.ago.all_week })
            # .where('sleep_logs.created_at >= ?', 1.week.ago.beginning_of_day) # In case is the the previous 7 days
            .order(duration: :desc)
  end
end
