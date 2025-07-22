class TodoItems::CheckOverdueJob < ApplicationJob
  queue_as :default

  def perform
    TodoItem.where(status: %i[pending done])
            .where("due_date < ?", Date.today)
            .find_each do |item|
      item.update(status: :late)
    end
  end
end
