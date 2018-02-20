class UpdateTask < Rectify::Command
  def initialize(task, params)
    @task = task
    @params = params
  end

  def call
    params[:sourcepriority] ? update_project : update_task
  end

  private

  def set_priorities
    @target_priority = @task.priority
    @source_priority = @params[:sourcepriority].to_i
  end

  def set_indices
    @project = @task.project
    @tasks = @project.tasks
    @start_index = @tasks.index { |task| task.priority == @source_priority }
    @end_index = @tasks.index { |task| task.priority == @target_priority }
  end

  def reassign_priorities
    source_task = @tasks.find { |task| task.priority == @source_priority }
    source_task.priority = @target_priority
    if @start_index < @end_index
      @tasks[(@start_index + 1)..@end_index].each { |task| task.priority -= 1 }
    else
      @tasks[@end_index...@start_index].each { |task| task.priority += 1 }
    end
  end

  def update_project
    set_priorities
    set_indices
    reassign_priorities
    return publish(:ok) if @project.save
    publish(:error, @project.errors.full_messages)
  end

  def update_task
    return publish(:ok) if @task.update_attributes(params)
    publish(:error, @task.errors.full_messages)
  end
end
