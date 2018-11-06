describe UpdateTask do
  context '#call' do
    let(:project) { create(:project, user: create(:user)) }
    let(:task) { create(:task, project: project) }
    let(:command) { described_class.new(task, params) }

    context 'updating fields' do
      let(:updated_content) { 'updated content' }
      let(:params) { { content: updated_content } }

      context 'with success' do
        it 'updates task attributes' do
          command.call
          expect(task.content).to eq(updated_content)
        end

        it 'publishes :ok event' do
          expect { command.call }.to publish(:ok)
        end
      end

      context 'with error' do
        it 'publishes :error event with error' do
          allow(task).to receive(:update_attributes).and_return(false)
          update_error = 'error updating task'
          allow(task).to(
            receive_message_chain('errors.full_messages')
            .and_return([update_error])
          )
          expect { command.call }.to publish(:error, [update_error])
        end
      end
    end

    context 'changing priorities' do
      context 'with success' do
        cases = {
          [0, 5] => [[*0..5], [5, 0, 1, 2, 3, 4]],
          [5, 0] => [[*0..5], [1, 2, 3, 4, 5, 0]],
          [0, 4] => [[*0..5], [4, 0, 1, 2, 3, 5]],
          [4, 0] => [[*0..5], [1, 2, 3, 4, 0, 5]],
          [1, 5] => [[*0..5], [0, 5, 1, 2, 3, 4]],
          [5, 1] => [[*0..5], [0, 2, 3, 4, 5, 1]],
          [2, 3] => [[*0..5], [0, 1, 3, 2, 4, 5]],
          [3, 2] => [[*0..5], [0, 1, 3, 2, 4, 5]],
          [3, 11] => [[3, 5, 6, 11, 12, 42, 98], [11, 4, 5, 10, 12, 42, 98]],
          [11, 3] => [[3, 5, 6, 11, 12, 42, 98], [4, 6, 7, 3, 12, 42, 98]],
          [6, 98] => [[3, 5, 6, 11, 12, 42, 98], [3, 5, 98, 10, 11, 41, 97]],
          [98, 6] => [[3, 5, 6, 11, 12, 42, 98], [3, 5, 7, 12, 13, 43, 6]],
          [5, 12] => [[3, 5, 6, 11, 12, 42, 98], [3, 12, 5, 10, 11, 42, 98]],
          [42, 6] => [[3, 5, 6, 11, 12, 42, 98], [3, 5, 7, 12, 13, 6, 98]]
        }
        cases.each do |priorities, sets|
          context "for priorities` sequence #{sets.first} drag "\
          "#{priorities.first} to #{priorities.last}" do
            let(:tasks) do
              sets.first.map do |number|
                create(:task, project: project, priority: number)
              end
            end

            let(:target) do
              tasks.find { |task| task.priority == priorities.last }
            end

            let(:command) do
              described_class.new(target, sourcepriority: priorities.first)
            end

            it "gives new #{sets.last} priorities` sequence" do
              command.call
              expect(tasks.each(&:reload).map(&:priority)).to eq(sets.last)
            end

            it 'publishes :ok event' do
              expect { command.call }.to publish(:ok)
            end
          end
        end
      end

      context 'with error' do
        it 'publishes :error event with error' do
          another_task = create(:task, project: project)
          params = { sourcepriority: another_task.priority }
          command = described_class.new(task, params)
          error = 'changing priorities error'
          allow(project).to receive(:save).and_return(false)
          allow(project).to(
            receive_message_chain('errors.full_messages')
            .and_return([error])
          )
          expect { command.call }.to publish(:error, [error])
        end
      end
    end
  end
end
