json.array!(@complaints) do |complaint|
  json.extract! complaint, :id, :subject, :matter, :key_words
  json.url complaint_url(complaint, format: :json)
end
