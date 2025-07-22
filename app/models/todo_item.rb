class TodoItem < ApplicationRecord
  enum :status, {
    pending: "pending",
    late: "late",
    done: "done",
    cancelled: "cancelled"
  }, default: "pending"

  validates :title, presence: true
  validates :status, inclusion: { in: statuses.keys }

  before_save :mark_as_late_if_expired

  def self.ransackable_attributes(auth_object = nil)
    %w[title description status due_date created_at]
  end

  private

  def mark_as_late_if_expired
    return unless due_date.present?
    return unless pending? || done?
    return unless due_date < Date.today

    self.status = "late"
  end
end
