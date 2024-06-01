module Indestructible
  extend ActiveSupport::Concern

  class DeleteNotAllowedError < StandardError; end

  class RecordDiscardedError < StandardError; end

  included do
    before_destroy :prevent_destroy
  end

  def prevent_destroy
    errors.add(:base, "Can't be deleted.")
    throw :abort
  end

  def delete
    destroy
  end

  def discard
    raise DeleteNotAllowedError unless discardable?
    update(discarded_at: Time.current) unless discarded?
  end

  def discardable?
    self.class.discardable?
  end

  def discarded?
    read_attribute("discarded_at").present?
  end

  class_methods do
    # Returns a discardable record by its id.
    #
    # If the record has been discarded, raises +RecordDiscardedError+
    # instead of +ActiveRecord::RecordNotFound+ to distinguish between
    # invalid records and discarded records, which may have different
    # semantics and error-handling considerations.
    #
    def find_discardable!(id)
      unscoped.find(id).tap do |obj|
        if obj.discarded?
          raise RecordDiscardedError
        end
      end
    end

    def kept
      where(discarded_at: nil)
    end

    def including_discarded
      unscope(where: :discarded_at)
    end

    def discarded
      including_discarded.where.not(discarded_at: nil)
    end

    def discardable?
      column_names.include?("discarded_at")
    end

    def destroy_all
      raise DeleteNotAllowedError
    end

    def delete_all
      destroy_all
    end
  end
end
