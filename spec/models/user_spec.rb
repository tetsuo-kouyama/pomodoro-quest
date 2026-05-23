require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    describe 'name' do
      it '20文字以下なら有効' do
        user = build(:user, name: 'a' * 20)
        expect(user).to be_valid
      end

      it '21文字以上なら無効' do
        user = build(:user, name: 'a' * 21)
        expect(user).to be_invalid
      end

      it '空なら無効' do
        user = build(:user, name: '')
        expect(user).to be_invalid
      end
    end

    describe 'email' do
      it '重複しなければ有効' do
        create(:user, email: 'test1@example.com')
        user = build(:user, email: 'test2@example.com')
        expect(user).to be_valid
      end

      it '重複すると無効' do
        create(:user, email: 'test@example.com')
        user = build(:user, email: 'test@example.com')
        expect(user).to be_invalid
      end

      it '空なら無効' do
        user = build(:user, email: '')
        expect(user).to be_invalid
      end
    end

    describe 'password' do
      it '6文字以上なら有効' do
        user = build(:user,
          password: '123456',
          password_confirmation: '123456')
        expect(user).to be_valid
      end

      it '5文字以下なら無効' do
        user = build(:user,
          password: '12345',
          password_confirmation: '12345')
        expect(user).to be_invalid
      end
    end

    describe 'gold' do
      it '初期値が100' do
        user = build(:user)
        expect(user.gold).to eq(100)
      end
    end
  end

  describe '#can_hire?' do
    let(:monster) { build(:monster, hire_cost: 100) }

    context '所持金が足りる場合' do
      it 'trueを返す' do
        user = build(:user, gold: 100)
        expect(user.can_hire?(monster)).to be true
      end
    end

    context '所持金が足りない場合' do
      it 'falseを返す' do
        user = build(:user, gold: 99)
        expect(user.can_hire?(monster)).to be false
      end
    end
  end

  describe '#hire_monster!' do
    let(:user) { create(:user, gold: 500) }
    let(:monster) { create(:monster, hire_cost: 100) }

    it 'モンスターを雇用できる' do
      owned_monster = user.owned_monsters.build(monster: monster)

      expect {
        user.hire_monster!(owned_monster, monster)
      }.to change(OwnedMonster, :count).by(1)

      expect(user.reload.gold).to eq(400)
    end
  end
end
