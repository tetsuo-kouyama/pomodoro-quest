require 'rails_helper'

RSpec.describe 'Adventures', type: :system do
  let(:user) { create(:user) }
  let(:monster) { create(:monster) }
  let!(:owned_monster) { create(:owned_monster, :party_member, user: user, monster: monster) }
  let!(:dungeon) { create(:dungeon) }

  before do
    login(user)
  end

  describe '冒険作成機能' do
    context '入力が正常' do
      it '冒険の作成に成功する' do
        visit new_adventure_path
        select "#{dungeon.name} (難易度: #{dungeon.difficulty})", from: 'ダンジョン'
        select '25分', from: '冒険時間'
        page.execute_script("document.querySelector('#adventure-form').submit()")

        expect(page).to have_current_path(new_adventure_path)
        expect(page).to have_content('冒険に出発しました')
      end
    end

    context '入力が不正' do
      it '冒険の作成に失敗する' do
        visit new_adventure_path
        create(:adventure, :ongoing, :with_members, user: user)
        select "#{dungeon.name} (難易度: #{dungeon.difficulty})", from: 'ダンジョン'
        select '25分', from: '冒険時間'

        click_button '冒険する'

        expect(page).to have_current_path(new_adventure_path)
        expect(page).to have_content('冒険中です')
      end
    end
  end
end
