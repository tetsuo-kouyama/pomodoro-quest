require 'rails_helper'

RSpec.describe 'Parties', type: :system do
  let(:user) { create(:user) }
  let(:monster) { create(:monster) }

  before do
    login(user)
  end

  describe 'モンスター一覧' do
    it '昇順に並んでいる' do
      create(:owned_monster, user: user, monster: monster, nickname: 'A')
      create(:owned_monster, user: user, monster: monster, nickname: 'B')
      create(:owned_monster, user: user, monster: monster, nickname: 'C')
      visit edit_party_path
      names = all('#inactive span')
          .map(&:text)

      expect(names).to eq(%w[A B C])
    end
  end

  describe 'パーティ編成機能' do
    describe '追加' do
      let!(:owned_monster) { create(:owned_monster, user: user, monster: monster) }

      context '空いている枠がある' do
        it 'モンスターを入れることができる' do
          visit edit_party_path
          click_link '入れる'

          expect(page).to have_selector('#active', text: owned_monster.nickname)
          expect(page).not_to have_selector('#inactive', text: owned_monster.nickname)
          expect(page).to have_content('外す')
        end
      end

      context '空いている枠がない' do
        it 'モンスターを入れることができない' do
          create_list(:owned_monster, 5, :active, user: user, monster: monster)
          visit edit_party_path
          click_link '入れる'

          expect(page).to have_content('これ以上編成できません')
        end
      end
    end

    describe '削除' do
      let!(:owned_monster) { create(:owned_monster, :active, party_position: 1, user: user, monster: monster) }

      context 'モンスターを外す' do
        it 'スロットが空になる' do
          visit edit_party_path
          click_link '外す'

          expect(page).to have_selector('#inactive', text: owned_monster.nickname)
          expect(page).not_to have_selector('#active', text: owned_monster.nickname)
          expect(page).not_to have_content('外す')
        end
      end
    end
  end
end
