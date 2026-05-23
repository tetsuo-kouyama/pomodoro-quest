require 'rails_helper'

RSpec.describe Monster, type: :model do
  describe 'バリデーション' do
    describe 'name' do
      it 'nameがあれば有効' do
        monster = build(:monster)
        expect(monster).to be_valid
      end

      it 'nameがなければ無効' do
        monster = build(:monster, name: "")
        expect(monster).to be_invalid
      end
    end

    describe 'hire_cost' do
      it '負なら無効' do
        monster = build(:monster, hire_cost: -1)
        expect(monster).to be_invalid
      end
    end
  end
end
