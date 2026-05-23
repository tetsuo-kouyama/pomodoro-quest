require 'rails_helper'

RSpec.describe 'OwnedMonsters', type: :system do
  let!(:user) { create(:user, gold: 100) }
  let!(:monster) { create(:monster, hire_cost: 100) }

  before do
    login(user)
    visit new_owned_monster_path
  end

  # Selenium + Headless Chrome の初回起動が不安定なため
  # warmup 用exampleを先頭に置いている
  it 'warmup' do
  end

  describe 'モンスター雇用機能' do
    context '所持金が足りている' do
      it 'モンスターを雇用できる' do
        fill_in 'ニックネーム(任意)', with: 'スライム'
        select "#{monster.name} (費用: #{monster.hire_cost}G)", from: '雇うモンスター'
        click_button '雇用する'

        expect(page).to have_current_path(owned_monsters_path)
        expect(page).to have_content("#{monster.name}を雇用しました")
      end
    end

    context '所持金が足りていない' do
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
end
