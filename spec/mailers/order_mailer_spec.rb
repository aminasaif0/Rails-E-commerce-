require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe OrderMailer, type: :mailer do
  describe '#order_confirmation' do
    let(:user) { create(:user) }
    let(:order) { create(:order, user: user) }

    before do
      Sidekiq::Testing.fake!
    end

    after do
      Sidekiq::Testing.inline!
    end

    it 'sends order confirmation email asynchronously' do
      expect {
        OrderMailer.order_confirmation(order).deliver_later
        }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.size }.by(1)


      Sidekiq::Worker.drain_all
    end
  end
end
