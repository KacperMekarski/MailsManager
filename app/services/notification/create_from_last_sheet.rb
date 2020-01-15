class Notification::CreateFromLastSheet
  include StatelessService

  def call
    Sheet::MapData.call(last_sheet)
  end

  private

  def last_sheet
    Sheet.order(:created_at).last
  end
end
