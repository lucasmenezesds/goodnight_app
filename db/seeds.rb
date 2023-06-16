# frozen_string_literal: true

# rubocop:disable Rails/Output
puts '===== Creating Users ====='
users = []
users[0] = User.find_or_create_by!(name: 'User_1', id: 'afdb0797-a044-4f42-b740-8656d83ba266')
users[1] = User.find_or_create_by!(name: 'User_2', id: 'bdb05163-9098-41df-8b3a-37b47465ea5e')
users[2] = User.find_or_create_by!(name: 'User_3', id: 'c7fd0dea-9ac9-417e-9965-8167307f5cdb')
users[3] = User.find_or_create_by!(name: 'User_4', id: 'de01cc8b-862a-47f7-897f-5e8871c3a6fb')
users[4] = User.find_or_create_by!(name: 'User_5', id: 'e2df7e87-eea2-46ca-99ad-8532f530deb9')
users[5] = User.find_or_create_by!(name: 'User_6', id: 'f9ef3f82-73bf-48cf-bf71-9a77084734f3')

puts '===== Creating following relationships ====='
# User1 follows User2 and User3
users[0].follow(users[1]) unless users[0].following?(users[1])
users[0].follow(users[2]) unless users[0].following?(users[2])

# User2 follows User1, User3 and User4
users[1].follow(users[0]) unless users[1].following?(users[0])
users[1].follow(users[2]) unless users[1].following?(users[2])
users[1].follow(users[3]) unless users[1].following?(users[3])

# User3 follows User5
users[2].follow(users[4]) unless users[2].following?(users[4])

# User4 and User7 don't follow anyone
# User5 and User6 don't have any followers

puts '===== Creating Sleep Logs ====='
# for the past 31 days
total_days = 31
users.each do |user|
  if user.sleep_logs.size >= total_days
    puts "Skipping #{user.name}, this one already have the amount of SleepLogs needed"
    next
  end

  total_days.times do |i|
    created_at = (total_days - i).days.ago.beginning_of_day
    woke_up_at = created_at + rand(3600..43_200) # 1..12 hours
    duration = TimeConcern.format_duration(Time.zone.at(woke_up_at - created_at))
    SleepLog.create(user: user, created_at: created_at, woke_up_at: woke_up_at, duration: duration)
  end
end
puts '===== All Done, Thanks for Waiting ====='
# rubocop:enable Rails/Output
