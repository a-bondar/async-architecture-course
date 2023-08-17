class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks
  def index
    @tasks = current_account.tasks if current_account.employee?
    @tasks = Task.all if current_account.manager? || current_account.admin?
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.account = Account.employee.sample

    if @task.save
      event = {
        event_name: 'TaskCreated',
        data: {
          employee_id: @task.account.public_id,
          cost: rand(-20..-10)
        }
      }

      Karafka.producer.produce_sync(topic: 'tasks-stream', payload: event.to_json)

      redirect_to @task, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      completed = task_params[:completed].true?

      if completed
        event = {
          event_name: 'TaskCompleted',
          data: {
            employee_id: @task.account.public_id,
            cost: rand(20..40)
          }
        }

        Karafka.producer.produce_sync(topic: 'tasks-stream', payload: event.to_json)
      end

      redirect_to @task, notice: "Task was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "Task was successfully destroyed.", status: :see_other
  end

  def shuffle
    return if current_account.employee?

    Task.pending.each do |task|
      if task.update(account: Account.employee.sample)

        event = {
          event_name: 'TaskAssigned',
          data: {
            employee_id: task.account.public_id,
            cost: rand(-20..-10)
          }
        }

        Karafka.producer.produce_sync(topic: 'tasks-stream', payload: event.to_json)
      end
    end

    redirect_to tasks_url, notice: "Tasks were successfully shuffled.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :completed, :account_id)
    end

  def current_account
    Account.find_by(id: session[:account]["id"])
  end
end
