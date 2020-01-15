require 'rails_helper'

RSpec.describe 'Wisper Subscription' do
  let(:subscriptions) { Wisper::GlobalListeners.registrations }

  shared_examples_for 'subscribed to Wisper event' do |event:, subscribers:, with: :call|
    subject(:broadcast) do
      subscriptions.each { |subscription| subscription.broadcast(event, self, *event_arguments) }
    end
    let(:event_arguments) { [publisher] }
    let(:publisher) { double.as_null_object }

    it 'checks if subscribers implement callable method' do
      expect(
        subscribers.all? { |subscriber| subscriber.respond_to?(with) }
      ).to eq true
    end

    it 'calls subscribers' do
      subscribers.each { |subscriber| allow(subscriber).to receive(with) }

      subscribers.each { |subscriber| expect(subscriber).to receive(with).with(*event_arguments) }
      broadcast
    end
  end
end
