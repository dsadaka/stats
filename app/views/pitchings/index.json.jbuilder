json.array!(@pitchings) do |pitching|
  json.extract! pitching, :id, :playerID, :yearID, :league, :teamID
  json.url pitching_url(pitching, format: :json)
end
