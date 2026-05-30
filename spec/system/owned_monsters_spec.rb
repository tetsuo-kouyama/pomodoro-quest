require 'rails_helper'

RSpec.describe 'OwnedMonsters', type: :system do
  let(:user) { create(:user) }

  before { login(user) }

  # Selenium + Headless Chrome の初回起動が不安定なため
  # warmup 用exampleを先頭に置いている
  # it 'warmup' do
  # end

  describe 'モンスター一覧機能' do
    it 'ヘッダーが表示されている' do
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.gold.to_s)
      expect(page).to have_button('ログアウト')
    end

    it 'フッターが表示されている' do
      expect(page).to have_content('ホーム')
      expect(page).to have_content('冒険')
    end

    context 'モンスターを所有している' do
      let!(:owned_monster) { create(:owned_monster, user: user) }

      it 'モンスターが表示される' do
        refresh
        expect(page).to have_content("1 / #{OwnedMonster::MAX_MONSTER_COUNT}")
        expect(page).to have_content(owned_monster.nickname)
      end
    end

    context 'モンスターを所有していない' do
      it 'モンスターが表示されない' do
        expect(page).to have_content(" 0 / #{OwnedMonster::MAX_MONSTER_COUNT}")
      end
    end
  end

  describe 'モンスター雇用機能' do
    let(:user) { create(:user, gold: 100) }
    let!(:monster) { create(:monster, hire_cost: 100) }

    before { visit new_owned_monster_path }

    context 'ゴールドが足りている' do
      it 'モンスターを雇用できる' do
        fill_in 'ニックネーム(任意)', with: 'スライム'
        select "#{monster.name} (費用: #{monster.hire_cost}G)", from: '雇うモンスター'
        click_button '雇用する'

        expect(page).to have_current_path(owned_monsters_path)
        expect(page).to have_content("#{monster.name}を雇用しました")
      end
    end

    context 'ゴールドが不足している' do
      let(:user) { create(:user, gold: 50) }

      it 'モンスターを雇用できない' do
        select "#{monster.name} (費用: #{monster.hire_cost}G)", from: '雇うモンスター'
        click_button '雇用する'

        expect(page).to have_content('ゴールドが足りません')
        expect(page).to have_current_path(new_owned_monster_path)
      end
    end

    context 'ニックネームが21文字以上' do
      it 'モンスターを雇用できない' do
        fill_in 'ニックネーム(任意)', with: 'a'* 21
        select "#{monster.name} (費用: #{monster.hire_cost}G)", from: '雇うモンスター'
        click_button '雇用する'

        expect(page).to have_content('maximum is 20 characters')
        expect(page).to have_current_path(new_owned_monster_path)
      end
    end
  end

  describe 'モンスター詳細機能' do
    let(:monster) { create(:monster, hire_cost: 100) }
    let(:owned_monster) { create(:owned_monster, user: user, monster: monster) }

    before { visit owned_monster_path(owned_monster) }

    it 'ステータスが表示される' do
      expect(page).to have_content('体力')
      expect(page).to have_content('攻撃力')
      expect(page).to have_content('防御力')
    end

    describe 'レベルアップ機能' do
      context 'ゴールドが足りている' do
        let(:user) { create(:user, gold: 200) }

        it 'レベルが1上がる' do
          click_button 'レベルアップ'
          expect(page).to have_content('レベルアップしました')
          expect(owned_monster.reload.level).to eq(2)
          expect(user.reload.gold).to eq(0)
        end
      end

      context 'ゴールドが不足している' do
        let(:user) { create(:user, gold: 100) }

        it 'レベルが上がらない' do
          click_button 'レベルアップ'
          expect(page).to have_content('ゴールドが足りません')
          expect(owned_monster.reload.level).to eq(1)
          expect(user.reload.gold).to eq(100)
        end
      end
    end

    describe '削除機能' do
      context '所有モンスターが2体以上' do
        it 'モンスターを削除できる' do
          delete_monster = create(:owned_monster, user: user)
          visit owned_monster_path(delete_monster)
          accept_confirm do
            click_link '解雇'
          end
          expect(page).to have_current_path(owned_monsters_path)
          expect(page).to have_content('モンスターを解雇しました')
          expect(OwnedMonster.exists?(delete_monster.id)).to be(false)
        end
      end

      context '所有モンスターが1体' do
        it '削除ボタンが表示されない' do
          expect(page).to have_current_path(owned_monster_path(owned_monster))
          expect(page).not_to have_link('解雇')
          expect(OwnedMonster.exists?(owned_monster.id)).to be(true)
        end
      end
    end

    describe '冒険中モンスターへの操作制限' do
      let!(:adventure) { create(:adventure, :ongoing, :with_member, user: user) }
      let(:adventuring_monster) { adventure.adventure_members.first.owned_monster }

      before { visit owned_monster_path(adventuring_monster) }

      it 'レベルアップボタンが表示されない' do
        expect(page).to have_content('冒険中')
        expect(page).not_to have_button('レベルアップ')
      end

      it '削除ボタンが表示されない' do
        expect(page).not_to have_link('解雇')
      end
    end
  end
end
