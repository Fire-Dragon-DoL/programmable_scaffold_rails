json.array!(@dummies) do |dummy|
  json.extract! dummy, :name, :will_invalidate
  json.url dummy_url(dummy, format: :json)
end
