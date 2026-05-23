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

  describe 'ステータス処理' do
    let(:monster) { create(:monster, name: 'test', base_hp: 10, base_atk: 5, base_def: 3) }
    let(:owned_monster) { create(:owned_monster, monster: monster, level: level) }

    describe 'HP' do
      context 'level 1' do
        let(:level) { 1 }

        it 'base値と同じになる' do
          expect(owned_monster.hp).to eq(monster.base_hp)
        end
      end

      context 'level 2' do
        let(:level) { 2 }

        it '成長分が加算される' do
          expect(owned_monster.hp).to eq(monster.base_hp + (level - 1) * 10)
        end
      end
    end

    describe '攻撃力' do
      context 'level 1' do
        let(:level) { 1 }

        it 'base値と同じになる' do
          expect(owned_monster.atk).to eq(monster.base_atk)
        end
      end

      context 'level 2' do
        let(:level) { 2 }

        it '成長分が加算される' do
          expect(owned_monster.atk).to eq(monster.base_atk + (level - 1) * 5)
        end
      end
    end

    describe '防御力' do
      context 'level 1' do
        let(:level) { 1 }

        it 'base値と同じになる' do
          expect(owned_monster.def).to eq(monster.base_def)
        end
      end

      context 'level 2' do
        let(:level) { 2 }

        it '成長分が加算される' do
          expect(owned_monster.def).to eq(monster.base_def + (level - 1) * 5)
        end
      end
    end
  end
end
