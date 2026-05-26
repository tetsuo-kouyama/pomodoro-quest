require 'rails_helper'

RSpec.describe AdventureMember, type: :model do
  describe 'バリデーション' do
    describe 'slot' do
      context '有効の場合' do
        it '有効なslot' do
          adventure_member = build(:adventure_member, slot: 1)
          expect(adventure_member).to be_valid
        end
      end

      context '無効の場合' do
        it '0' do
          adventure_member = build(:adventure_member, slot: 0)
          expect(adventure_member).to be_invalid
        end

        it 'パーティサイズより大きい値' do
          adventure_member = build(:adventure_member, slot: OwnedMonster::MAX_PARTY_SIZE + 1)
          expect(adventure_member).to be_invalid
        end

        it '空' do
          adventure_member = build(:adventure_member, slot: nil)
          expect(adventure_member).to be_invalid
        end
      end
    end
  end
end
