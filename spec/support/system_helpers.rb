module SystemHelpers
  def login(user, email: user.email, password: 'password')
    visit login_path
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
    click_button 'ログイン'
    expect(page).to have_current_path(owned_monsters_path)
  end
end
