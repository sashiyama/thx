require 'rails_helper'

RSpec.describe GiveThx do
  describe 'システムからのThx自動付与' do
    context '付与履歴が存在しない場合' do
      let(:user){ create(:user, thx_balance: 100) }
      it 'thx_balanceがリセットされINIT_THXの値になる' do
        expect(user.thx_balance).to eq (100)
        GiveThx.run
        expect(User.find(user.id).thx_balance).to eq User::INIT_THX
      end
    end

    context '付与履歴が存在する場合' do
      it 'thx_balanceはリセットされず元のままの' do
        create(:giving_history, giving_date: Time.zone.today)
        user = create(:user, thx_balance: 100)
        GiveThx.run
        expect(User.find(user.id).thx_balance).to eq 100
      end
    end

    context '最新の付与履歴がGIVING_PERIOD以上な場合' do
      it 'thx_balanceがリセットされINIT_THXの値になる' do
        create(:giving_history, giving_date: Time.zone.today)
        user = create(:user, thx_balance: 100)
        travel_to(Time.zone.today + GivingHistory::GIVING_PERIOD) do
          GiveThx.run
          expect(User.find(user.id).thx_balance).to eq User::INIT_THX
        end
      end
    end
  end
end
