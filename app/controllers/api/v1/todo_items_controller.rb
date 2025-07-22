module Api
  module V1
    class TodoItemsController < ApplicationController
      before_action :set_todo_item, only: [ :show, :update, :destroy ]

      def index
        q = TodoItem.ransack(params[:q])
        @todo_items = q.result
        render json: @todo_items
      end

      def show
        render json: @todo_item
      end

      def create
        @todo_item = TodoItem.new(todo_item_params)
        if @todo_item.save
          render json: @todo_item, status: :created
        else
          render json: @todo_item.errors, status: :unprocessable_entity
        end
      end

      def update
        if @todo_item.update(todo_item_params)
          render json: @todo_item
        else
          render json: @todo_item.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if @todo_item.update(status: :cancelled)
          head :no_content
        else
          render json: @todo_item.errors, status: :unprocessable_entity
        end
      end

      private

      def set_todo_item
        @todo_item = TodoItem.find(params[:id])
      end

      def todo_item_params
        params.require(:todo_item).permit(:title, :description, :status, :due_date)
      end
    end
  end
end
