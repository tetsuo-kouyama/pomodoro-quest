require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe 'POST /login' do
    context '入力が正常' do
      it 'ログインに成功する' do
        post login_path, params: {
          session: {
            email: user.email,
            password: user.password
          }
        }

        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
      end
    end

    context '入力が不正' do
      it 'ログインに失敗する' do
        post login_path, params: {
          session: {
            email: user.email,
            password: "wrong_password"
          }
        }

        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
