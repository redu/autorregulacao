# encoding: UTF-8
class CooperationForm < BaseForm
  attr_reader :answer, :user

  attribute :answer_id, Integer
  attribute :user_id, Integer
  attribute :rationale, String
  attribute :recommendation, String

  validates :answer_id, presence: true
  validates :user_id, presence: true
  validates :rationale, presence: true
  validates :recommendation, presence: true
  validate :already_cooperated

  def persist!
    attrs = { rationale: rationale, recommendation: recommendation }
    @cooperation = answer.cooperations.create(attrs) do |r|
      r.user_id = user_id
      r.answer_id = answer_id
    end
  end

  def answer
    @answer ||= Answer.find_by_id(answer_id)
  end

  protected

  def already_cooperated
    return unless answer_id && user_id
    if answer.cooperations.exists?(user_id: user_id)
      errors.add(:base, "Você já cooperou")
    end
  end
end
