require 'cancan/matchers'

describe User do
  context 'abilities' do
    let(:user) { create(:user) }
    subject { Ability.new(user) }

    it { is_expected.to be_able_to(:create, Project) }
    it { is_expected.to be_able_to(:create, Task) }

    [:read, :update, :destroy].each do |action|
      it "allows to #{action} this user`s project" do
        is_expected.to be_able_to(action, create(:project, user: user))
      end

      it "doesn`t allow to #{action} other user`s project" do
        is_expected.not_to be_able_to(
          action, create(:project, user: create(:user))
        )
      end
    end

    [:update, :destroy].each do |action|
      it "allows to #{action} this user`s project`s task" do
        is_expected.to be_able_to(
          action, create(:task, project: create(:project, user: user))
        )
      end

      it "doesn`t allow to #{action} other user`s project`s task" do
        is_expected.not_to be_able_to(
          action, create(:task, project: create(:project, user: create(:user)))
        )
      end
    end
  end
end
