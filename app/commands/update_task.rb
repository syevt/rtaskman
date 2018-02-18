class UpdateTask < Rectify::Command
  def initialize(task, params)
    @task = task
    @params = params
  end

  def call
    if params[:sourcepriority]
      publish reassign_priorities ? :ok : :error
    else
      publish @task.update_attributes(@params) ? :ok : :error
    end
  end

  private

  def reassign_priorities
    target_priority = @task.priority
    source_priority = @params[:sourcepriority].to_i
    project = @task.project
    tasks = project.tasks
    # byebug
    start_index = tasks.index { |task| task.priority == source_priority }
    end_index = tasks.index { |task| task.priority == target_priority }
    source_task = tasks.find { |task| task.priority == source_priority }
    source_task.priority = target_priority
    if start_index < end_index
      tasks[(start_index + 1)..end_index].each { |task| task.priority -= 1 }
    else
      tasks[end_index...start_index].each { |task| task.priority += 1 }
    end
    project.save
  end
end
