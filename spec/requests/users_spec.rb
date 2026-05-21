require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'POST /users' do
    context '入力が正常' do
      it 'ユーザー登録に成功' do
        expect {
          post users_path, params: {
            user: {
              name: "test",
              email: "test@example.com",
              password: "password",
              password_confirmation: "password"
            }
          }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(owned_monsters_path)
      end
    end

    context '入力が不正' do
      it 'ユーザー登録に失敗する' do
        expect {
          post users_path, params: {
            user: {
              name: "",
              email: "",
              password: "123",
              password_confirmation: "123"
            }
          }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
