module RSpec
  module Specs # :nodoc:
    def specify_user_permissions(permissions:, context_name: nil) # :nodoc:
      describe context_name || 'ability' do
        subject { Ability.new user }

        permissions.each do |permission, abilities|
          name = permission.blank? ? 'no' : permission.split('#').last

          context "when a user has #{name} permissions" do
            let(:group) { build :group, permissions: [permission.to_s].compact_blank }
            let(:user) { build :user, groups: [group] }

            Array.wrap(abilities[:can]).each do |action|
              it { is_expected.to be_able_to action, described_class }
            end

            Array.wrap(abilities[:cannot]).each do |action|
              it { is_expected.not_to be_able_to action, described_class }
            end
          end
        end
      end
    end

    def specify_factory(factory_name: nil, traits: nil, context_name: nil) # :nodoc:
      factory_name = described_class.name.underscore.gsub('/', '_').to_sym unless factory_name

      describe context_name || 'factory' do
        subject { build_stubbed factory_name }

        it { is_expected.to be_valid }

        Array.wrap(traits).each do |trait|
          context "with #{trait} trait" do
            subject { build_stubbed factory_name, trait }

            it { is_expected.to be_valid }
          end
        end
      end
    end

    def specify_associations(belongs_to: nil, has_many: nil, context_name: nil) # :nodoc:
      describe context_name || 'associations' do
        Array.wrap(belongs_to).each do |association|
          it { is_expected.to belong_to association }
        end

        Array.wrap(has_many).each do |association, dependent|
          it { is_expected.to have_many(association).dependent(dependent) }
        end
      end
    end
  end
end
