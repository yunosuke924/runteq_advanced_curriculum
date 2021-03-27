# == Schema Information
#
# Table name: sites
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  subtitle    :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :site do
    name { "blog" }
    subtitle { "very awesome" }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
