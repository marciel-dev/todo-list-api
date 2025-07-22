require 'swagger_helper'

RSpec.describe 'TodoItems API', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/api/v1/todo_items' do
    get 'Lista tarefas com filtros Ransack' do
      tags 'TodoItems'
      produces 'application/json'
      parameter name: :q, in: :query, schema: {
        type: :object,
        properties: {
          status_eq: { type: :string },
          title_cont: { type: :string },
          description_cont: { type: :string },
          due_date_eq: { type: :string, format: :date },
          created_at_gteq: { type: :string, format: :date }
        }
      }

      response '200', 'OK' do
        before do
          TodoItem.create!(title: 'Ransack Test', status: 'pending')
        end

        run_test!
      end
    end

    post 'Cria uma nova tarefa' do
      tags 'TodoItems'
      consumes 'application/json'
      parameter name: :todo_item, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          status: { type: :string, enum: %w[pending done cancelled late] },
          due_date: { type: :string, format: :date }
        },
        required: %w[title status]
      }

      response '201', 'Criado' do
        let(:todo_item) { { title: 'Exemplo', status: 'pending' } }
        run_test!
      end

      response '422', 'Erro de validação' do
        let(:todo_item) { { title: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/todo_items/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Exibe uma tarefa' do
      tags 'TodoItems'
      produces 'application/json'

      response '200', 'OK' do
        let(:id) { TodoItem.create!(title: 'Show Test', status: 'pending').id }
        run_test!
      end

      response '404', 'Não encontrado' do
        let(:id) { '0' }
        run_test!
      end
    end

    put 'Atualiza uma tarefa' do
      tags 'TodoItems'
      consumes 'application/json'
      parameter name: :todo_item, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          status: { type: :string, enum: %w[pending done cancelled late] },
          due_date: { type: :string, format: :date }
        }
      }

      response '200', 'Atualizado com sucesso' do
        let(:id) { TodoItem.create!(title: 'Original', status: 'pending').id }
        let(:todo_item) { { title: 'Atualizado', status: 'done' } }
        run_test!
      end

      response '422', 'Erro de validação' do
        let(:id) { TodoItem.create!(title: 'Inválido', status: 'pending').id }
        let(:todo_item) { { title: '' } }
        run_test!
      end
    end

    delete 'Cancela uma tarefa (soft delete)' do
      tags 'TodoItems'

      response '204', 'Cancelado com sucesso' do
        let(:id) { TodoItem.create!(title: 'A cancelar', status: 'pending').id }
        run_test!
      end

      response '422', 'Erro ao cancelar' do
        let(:id) { '0' }
        run_test!
      end
    end
  end
end
