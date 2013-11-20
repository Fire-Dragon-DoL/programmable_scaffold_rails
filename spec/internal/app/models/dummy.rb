class Dummy < ActiveRecord::Base

  validate :dummy_will_invalidate?

  def dummy_will_invalidate?
    self.errors.add(:will_invalidate, '') if self.will_invalidate?

    !self.will_invalidate?
  end

end