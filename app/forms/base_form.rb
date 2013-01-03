class BaseForm
  include Virtus
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end
end
