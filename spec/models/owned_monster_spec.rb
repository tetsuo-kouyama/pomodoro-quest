require 'rails_helper'

RSpec.describe OwnedMonster, type: :model do
  describe 'バリデーション' do
    describe 'nickname' do
      it '20文字以下なら有効' do
        owned_monster = build(:owned_monster, nickname: 'a' * 20)
        expect(owned_monster).to be_valid
      end

      it '21文字以上なら無効' do
        owned_monster = build(:owned_monster, nickname: 'a' * 21)
        expect(owned_monster).to be_invalid
      end

      it '空でも有効' do
        owned_monster = build(:owned_monster, nickname: '')
        expect(owned_monster).to be_valid
      end

      it 'nilでも有効' do
        owned_monster = build(:owned_monster, nickname: nil)
        expect(owned_monster).to be_valid
      end

      it 'ニックネームが空なら種族の名前が入る' do
        monster = create(:monster)
        owned_monster = create(:owned_monster, monster: monster, nickname: '')
        expect(owned_monster.nickname).to eq(monster.name)
      end
    end
  end
end
