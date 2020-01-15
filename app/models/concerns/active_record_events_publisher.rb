module Concerns::ActiveRecordEventsPublisher
  extend ActiveSupport::Concern

  included do
    include Wisper::Publisher

    after_create "broadcast_#{model_name.singular}_created".to_sym
    after_save "broadcast_#{model_name.singular}_changed".to_sym

    after_commit "broadcast_#{model_name.singular}_created_async".to_sym, on: :create
    after_commit "broadcast_#{model_name.singular}_updated_async".to_sym, on: :update
    after_commit "broadcast_#{model_name.singular}_changed_async".to_sym

    define_method "broadcast_#{model_name.singular}_created" do
      broadcast("#{model_name.singular}_created".to_sym, self, saved_changes)
    end

    define_method "broadcast_#{model_name.singular}_changed" do
      broadcast("#{model_name.singular}_changed".to_sym, self, saved_changes)
    end

    define_method "broadcast_#{model_name.singular}_changed_async" do
      broadcast("#{model_name.singular}_changed_async".to_sym, self, changeset_from_transaction)
    end

    define_method "broadcast_#{model_name.singular}_created_async" do
      broadcast("#{model_name.singular}_created_async".to_sym, self, changeset_from_transaction)
    end

    define_method "broadcast_#{model_name.singular}_updated_async" do
      broadcast("#{model_name.singular}_updated_async".to_sym, self, changeset_from_transaction)
    end

    private

    def changeset_from_transaction
      transaction_changed_attributes.each_with_object({}) do |(name, old_value), changeset|
        changeset[name] = [old_value, self[name]] if old_value != self[name]
      end
    end
  end
end
