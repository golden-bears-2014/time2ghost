class TextWorker
  include Sidekiq::Worker

  def perform
    TwilioModel.send_all_texts_for_now
  end
end
