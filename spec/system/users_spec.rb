require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ユーザー登録' do
    it '登録に成功する' do
      visit new_user_path
      fill_in 'ユーザー名', with: 'test'
      fill_in 'メールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード(確認)', with: 'password'
      click_button '登録'

      expect(page).to have_content '登録しました'
      expect(page).to have_current_path(root_path)
    end

    it '登録に失敗する' do
      visit new_user_path
      fill_in 'ユーザー名', with: 'test'
      fill_in 'メールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード(確認)', with: 'wrong_password'
      click_button '登録'

      expect(page).to have_content '登録に失敗しました'
      expect(page).to have_current_path(new_user_path)
    end
  end
end
