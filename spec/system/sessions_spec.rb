require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン処理' do
    it 'ログインに成功する' do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'

      expect(page).to have_content 'ログインしました'
      expect(page).to have_current_path(owned_monsters_path)
    end

    it 'ログインに失敗する' do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'wrong_password'
      click_button 'ログイン'

      expect(page).to have_content 'ログインに失敗しました'
      expect(page).to have_current_path(login_path)
    end
  end

  describe 'ログアウト処理' do
    it 'ログアウトする' do
      login(user)
      visit owned_monsters_path
      click_button 'ログアウト'

      expect(page).to have_content('ログアウトしました')
      expect(page).not_to have_button('ログアウト')
      expect(page).to have_current_path(root_path)
    end
  end
end
