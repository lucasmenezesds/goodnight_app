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
end
