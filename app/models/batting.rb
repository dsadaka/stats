class Batting < ActiveRecord::Base
  require 'csv'
  belongs_to :master, :primary_key => :playerID, :foreign_key => :playerID

  validates_presence_of :master, :message => "Player not found.  Invalid playerID."

  scope :most_improved_ba_from, lambda { |year1, year2, limit|
    find_by_sql(
        ['select distinct a.playerID as playerID,  m.nameLast as LastName, m.nameFirst as FirstName, a.yearID as year2,
                 b.yearID as year1,a.H as H2, b.H as H1,a.AB as ab2, b.AB as ab1, a.ba as ba2, b.ba as ba1,
                 (a.ba - b.ba) as badiff , ( (a.ba - b.ba) / b.ba * 100) as pctImproved
            from
                (select playerID, yearID,H, CAST(H AS REAL)/AB as ba, AB from battings where yearID = :year2 ) a
              left join
                (select playerID, yearID,H, CAST(H AS REAL)/AB as ba, AB from battings where yearID = :year1 ) b on b.playerID = a.playerID
              inner join
                (select playerID, nameLast, nameFirst from masters) m on m.playerID = b.playerID
            where badiff > 0 and a.AB >= 200 and b.AB >= 200
            order by badiff desc limit :limit', :year1 => year1, :year2 => year2, :limit => limit])

  }

  scope :slugging_pct_for_team_and_year, lambda { |team, year|
    find_by_sql(['select m.playerID as playerID, nameLast as LastName, nameFirst as FirstName,
                        coalesce((CAST((H - twoB - threeB - HR) + (2 * twoB) + (3 * threeB) + (4 * HR) AS REAL)) / AB * 100, 0) as SluggingPct
                  from masters m
                  inner join battings b on b.playerID = m.playerID
                  where b.teamID= :team and b.yearID = :year
                  order by SluggingPct desc;', :team => team, :year => year])
  }

  # Return single row containing top HR,RBI and BA players for given year
  scope :top_stats_for_year_and_ab, lambda { |year, ab|
    find_by_sql(
      ['select * from
        (select playerID as playerID_RBI, yearID as yearID_RBI,RBI
          from battings
          where yearID = :year and AB >= :ab
          order by RBI desc
          limit 1)
        inner join
          (select playerID as playerID_HR, yearID as yearID_HR,HR
            from battings
            where yearID = :year and AB >= :ab
            order by HR desc
            limit 1)
        inner join
          (select playerID as playerID_BA, yearID as yearID_BA,CAST(H AS REAL)/AB as BA
          from battings
          where yearID = :year and AB >= :ab
          order by BA desc
          limit 1)',
       :year => year, :ab => ab])
  }

  def self.import(filename = nil, init = true)
    unless filename
      return "Please select an input file"
    end

    puts "Deleting existing records..."
    delete_all if init
    puts "Done. Begining Import"

    errors = []

    CSV.foreach(filename, {:headers => true, :skip_lines => /\n/, :skip_blanks => true }) do |row|
      begin
        puts "Rec #{$.}: #{CSV.generate_line(row)}" if ($. == 1 || $. % 100 == 0)
        if row.fetch('playerID').to_s.empty?
          raise "playerID not provided for #{row.fetch('nameFirst')} #{row.fetch('nameLast')}"
        else
          b = create(  playerID: row.fetch('playerID'),
                       yearID: row.fetch('yearID'),
                       league: row.fetch('league'),
                       teamID: row.fetch('teamID'),
                       G: row.fetch('G') || 0,
                       AB: row.fetch('AB') || 0,
                       R: row.fetch('R') || 0,
                       H: row.fetch('H') || 0,
                       twoB: row.fetch('2B') || 0,
                       threeB: row.fetch('3B') || 0,
                       HR: row.fetch('HR') || 0,
                       RBI: row.fetch('RBI') || 0,
                       SB: row.fetch('SB') || 0,
                       CS: row.fetch('CS') || 0,
                    )

          unless b.errors.empty?
            msg = "Error on line # #{$.}: #{b.errors.full_messages.join(",")}: #{row.fetch('playerID')}. Skipped"
            errors << msg
            puts msg
          end

        end
      rescue Exception => e
        msg =  "Error on line # #{$.}: [#{e.to_s}]. Skipped"
        puts msg
        errors << msg
        Rails.logger.debug msg
        next
      end
    end

    return errors
  end

  def self.triple_crown (year = nil, ab = 400)
    winner = nil
    if year
      ts = top_stats_for_year_and_ab(year,ab).first
      winner = ts.playerID_RBI if [ts.playerID_RBI, ts.playerID_HR, ts.playerID_BA].grep(ts.playerID_RBI).size == 3
    end
    return winner
  end

end
