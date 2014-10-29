json.array!(@battings) do |batting|
  json.extract! batting, :id, :playerID, :yearID, :league, :teamID, :G, :AB, :R, :H, :twoB, :threeB, :HR, :RBI, :SB, :CS
  json.url batting_url(batting, format: :json)
end
