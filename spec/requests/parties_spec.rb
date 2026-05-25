require 'rails_helper'

RSpec.describe "Parties", type: :request do
  let(:user) { create(:user) }
  let(:monster) { create(:monster) }
  let!(:owned_monster) { create(:owned_monster, user: user, monster: monster) }

  before { login(user) }

  describe 'PATCH /party/add_monster' do
    context '編成数に空きがある' do
      it 'モンスターを編成できる' do
        patch add_monster_party_path,
          params: {
            owned_monster_id: owned_monster.id
          },
          headers: {
            'ACCEPT' => 'text/vnd.turbo-stream.html'
          }
        owned_monster.reload

        expect(owned_monster.active).to be(true)
        expect(owned_monster.party_position).to eq(1)
        expect(response).to have_http_status(:success)
      end
    end

    context '編成数が上限' do
      it 'モンスターを編成できない' do
        create_list(:owned_monster, 5, :active, user: user, monster: monster)
        patch add_monster_party_path,
          params: {
            owned_monster_id: owned_monster.id
          },
          headers: {
            'ACCEPT' => 'text/vnd.turbo-stream.html'
          }
        owned_monster.reload

        expect(owned_monster.active).to be(false)
        expect(owned_monster.party_position).to be_nil
        expect(flash[:alert]).to eq('これ以上編成できません')
      end
    end
  end

  describe 'PATCH /party/remove_monster' do
    let!(:owned_monster) { create(:owned_monster, :active, party_position: 1, user: user, monster: monster) }

    it 'モンスターを編成から外すことができる' do
      patch remove_monster_party_path,
        params: {
          owned_monster_id: owned_monster.id
        },
        headers: {
          'ACCEPT' => 'text/vnd.turbo-stream.html'
        }
      owned_monster.reload

      expect(owned_monster.active).to be(false)
      expect(owned_monster.party_position).to be_nil
      expect(response).to have_http_status(:success)
    end
  end
end
