module HrefTo
  extend ActiveSupport::Concern

  # Fetches the URL with specified rel on representation
  def href_to(rel)
    if repr = self.representation
      links = repr.with_indifferent_access["links"]
      links.select! { |link| link["rel"] == rel }
      links.length == 0 ? nil : links.first["href"]
    end
  end
end
