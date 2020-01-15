shared_examples_for 'active records event publisheable' do |model_name, factory|
  describe 'after_commit' do
    let(:factory_name) { factory || model_name }

    describe 'on create' do
      let(:object) { build(factory_name) }

      it "broadcasts :#{model_name}_changed_async event" do
        expect do
          object.save
        end.to broadcast("#{model_name}_changed_async".to_sym, object, hash_including('created_at'))
      end
    end

    describe 'on update' do
      let!(:object) { create(factory_name) }

      it "broadcasts :#{model_name}_changed_async event" do
        expect do
          object.update(updated_at: Time.current)
        end.to broadcast("#{model_name}_changed_async".to_sym, object, hash_including('updated_at'))
      end
    end

    describe 'on destroy' do
      let!(:object) { create(factory_name) }

      it "broadcasts :#{model_name}_changed_async event" do
        expect do
          object.destroy
        end.to broadcast("#{model_name}_changed_async".to_sym, object, {})
      end
    end
  end
end
