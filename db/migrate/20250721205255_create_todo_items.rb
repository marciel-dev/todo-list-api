class CreateTodoItems < ActiveRecord::Migration[8.0]
  def change
    create_table :todo_items do |t|
      t.string :title
      t.text :description
      t.string :status, null: false, default: "pending"
      t.date :due_date

      t.timestamps
    end

    add_index :todo_items, :status
    add_index :todo_items, :due_date
  end
end
