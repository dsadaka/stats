class Master < ActiveRecord::Base
  self.primary_key = :playerID
  require 'csv'

  has_many :battings, :primary_key => :playerID, :foreign_key => :playerID, :dependent => :destroy
  has_many :pitchings, :primary_key => :playerID, :foreign_key => :playerID, :dependent => :destroy

  def self.import(filename = nil, init = true)
    unless filename
      return ["Please select an input file"], 0
    end
    puts "Deleting existing records..."
    delete_all if init
    puts "Done. Begining Import"
    recs_uploaded = 0
    errors = []
      CSV.foreach(filename, {:headers => true, :skip_blanks => true}) do |row|
        begin
          puts "Rec #{$.}: #{CSV.generate_line(row)}" if ($. == 1 || $. % 100 == 0)
          if row.fetch('playerID').to_s.empty?
            raise "playerID not provided for #{row.fetch('nameFirst')} #{row.fetch('nameLast')}"
          else
            m = create(  playerID: row.fetch('playerID'),
                         birthYear: row.fetch('birthYear'),
                         nameFirst: row.fetch('nameFirst'),
                         nameLast: row.fetch('nameLast')
                      )
            unless m.errors.empty?
              msg = "Error on line # [#{$.}]: #{m.errors.full_messages.join(",")}: #{row.fetch('playerID')}. Skipped"
              errors << msg
              puts msg
            end

            recs_uploaded += 1
          end
        rescue Exception => e
          msg = case e.to_s
                  when /is not unique/
                    "[playerID is not unique]: #{row.fetch('playerID')} Name: #{row.fetch('nameLast')},#{row.fetch('nameFirst')}"
                  else
                    "[#{e.to_s}]"
                end
          errors << "Error on line # [#{$.}]: " + msg + ". Skipped"
          Rails.logger.debug msg
          puts msg
          next
        end
      end
    return errors
  end

end
