require 'rails_helper'

RSpec.describe 'OwnedMonsters', type: :request do
  describe 'GET /owned_monsters' do
    let(:user) { create(:user) }

    context 'ログイン済み' do
      it '一覧画面を表示できる' do
        login(user)
        get "/owned_monsters"
        expect(response).to have_http_status(:success)
      end
    end

    context '未ログイン' do
      it 'ログイン画面へリダイレクトされる' do
        get "/owned_monsters"
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'POST /owned_monsters' do
    let(:user) { create(:user, gold: 100) }
    let(:monster) { create(:monster, hire_cost: 100) }
    before { login(user) }

    context '所持金が足りている' do
      it '雇用できる' do
        expect do
          post owned_monsters_path,
            params: {
              owned_monster: {
                monster_id: monster.id
              }
            }
        end.to change(OwnedMonster, :count).by(1)

        expect(user.reload.gold).to eq(0)
        expect(response).to redirect_to(owned_monsters_path)
      end
    end

    context '所持金が不足している' do
      let(:user) { create(:user, gold: 50) }

      it '雇用できない' do
        expect do
          post owned_monsters_path,
            params: {
              owned_monster: {
                monster_id: monster.id
              }
            }
        end.not_to change(OwnedMonster, :count)

        expect(user.reload.gold).to eq(50)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
