json.array!(@masters) do |master|
  json.extract! master, :id, :playerID, :birthYear, :nameFirst, :nameLast
  json.url master_url(master, format: :json)
end
