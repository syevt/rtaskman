class UpdateTask < Rectify::Command
  def initialize(task, params)
    @task = task
    @params = params
  end

  def call
    if params[:targetpriority]
      puts 'no luck...'
    else
      publish @task.update_attributes(@params) ? :ok : :error
    end
  end
end
