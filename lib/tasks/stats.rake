namespace :stats do

  desc "Import CSV files to master, init=no prevents emptying master first."
  task :import_master, [:filename, :init] => [:environment] do |task,args|
    include ActionView::Helpers::TextHelper
    args.with_defaults(:filename => './Master-small.csv', :init => "yes")
    init = args.init.to_s.downcase == "yes"

    # Confirm with user
    msg = "Import from #{args.filename} to master "
    msg << "after deleting any existing records" if init

    unless confirm(msg)
      puts "Chicken."
      exit(1)
    end

    # Setup a log file
    logger = setup_log_file(task)
    logger.info "Import from #{args.filename} to master #{"after deleting any existing records" if args.init.to_s == "yes"}"

    # Get started
    errors = []    # Let's hope it stays this way!

    if File.exist?(args.filename) and File.size(args.filename) > 0
      errors = Master.import(args.filename, init)
      log_errors(logger, errors,:error)
    else
      errors << "#{args.filename} not found or is empty."
      log_errors(logger, errors,:fatal)
    end

    puts "Job Done. #{pluralize(errors.length, 'error')} logged to #{logger.filename}"

  end

  desc "Import CSV file to battings, init=no prevents emptying battings first."
  task :import_batting, [:filename, :init] => [:environment] do |task,args|
    include ActionView::Helpers::TextHelper
    args.with_defaults(:filename => './Batting-07-12.csv', :init => "yes")
    init = args.init.to_s.downcase == "yes"

    # Confirm with user
    msg = "Import from #{args.filename} to battings table "
    msg << "after deleting any existing records" if init

    unless confirm(msg)
      puts "You're no fun :)"
      exit(1)
    end

    # Setup a log file
    logger = setup_log_file(task)
    logger.info "Import from #{args.filename} to master #{"after deleting any existing records" if args.init.to_s == "yes"}"

    # Get started
    errors = []    # Let's hope it stays this way!

    if File.exist?(args.filename) and File.size(args.filename) > 0
      errors = Batting.import(args.filename, init)
      log_errors(logger, errors,:error)
    else
      errors << "#{args.filename} not found or is empty."
      log_errors(logger, errors,:fatal)
    end

    puts "Job Done. #{pluralize(errors.length, 'error')} logged to #{logger.filename}"

  end

  desc "Print out Baseball batting stats to STDOUT"
  task :print => :environment do |task|

    # Most Improved
    puts "\nTop 10 Most improved Batting Averages from 2009 to 2010."
    puts "_______________________________________________________________________________"
    bas=Batting.most_improved_ba_from(2009,2010,10)
    printf("%-20s %s %s %s\n", "", "        2009        ", "|", "        2010        ")
    printf("%-20s %6s %6s %6s | %6s %6s %6s   %12s\n", "Name", "Hits", "AB", "BA", "Hits", "AB", "BA", "Improved %")
    puts "-------------------------------------------------------------------------------"
    bas.each {|ba|  printf("%-20s %6d %6d %6d | %6d %6d %6d %12.1f %\n",
                          ba.LastName + ", " + ba.FirstName,
                          ba.H1,
                          ba.ab1,
                          ba.ba1,
                          ba.H2,
                          ba.ab2,
                          ba.ab2,
                          ba.pctImproved
                    )
    }

    # Slugging Percentages
    printf("\nSlugging Percentages for Oakland A's with available stats in 2007")
    printf("\n_________________________________________________________________\n\n")
    sps=Batting.slugging_pct_for_team_and_year("OAK", 2007)
    printf("%-20s   %12s\n", "Name", "Slugging %")
    printf("-----------------------------------\n")
    sps.each {|sp| printf("%-20s %12.1f %\n", sp.LastName + ", " + sp.FirstName, sp.SluggingPct) unless sp.SluggingPct == 0}

    # Triple Crown
    printf("\nTriple Crown\n")
    printf("-----------\n")
    printf("Disclaimer:  These results used AB instead of PA since PA was not available.\n")
    printf("instructions to include players with an AB of 400 or more resulted in NO winner for 2012\n")
    printf("since Melky Cabrera actually had the highest AVG with this constraint.\n")
    printf("This, of course, contradicts the MLB who awarded the Triple Crown to Miguel Cabrera.\n")
    printf("However, raising the AB to 600 or more, gives the correct results as displayed below.\n\n")
    print_tcw(2011,400)
    print_tcw(2011,600)
    print_tcw(2012,400)
    print_tcw(2012,600)

    puts
    puts("Graciously compiled by:")
    puts("Dan Sadaka, Datakey Inc.")
    puts("Palm Beach Gardens, FL")
    puts("October, 2014")
    printf "\nOmnibus rebus bonis finis est\n\n"
  end

  def print_tcw(year,ab)
    tcw=Master.find(Batting.triple_crown(year,ab)) rescue nil
    tcw = "#{tcw.nameLast}, #{tcw.nameFirst}" if tcw
    tcw ||= "None"
    printf("Year: #{year}, AB: #{ab} Winner: %s\n", tcw)
  end

  def setup_log_file(task)
    begtime = Time.now()
    log_file_name = %Q{#{Rails.root}/log/#{%Q{#{task.to_s.tr(':','-')}-#{begtime.strftime("%m%d%y%I%M")}.log}}}
    logger = Logger.new(log_file_name)
    logger.class.module_eval { attr_accessor :filename}
    logger.filename = log_file_name
    logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime.strftime("%Y-%m-%d %H:%M")}: [#{severity}] #{msg}\n"
    end
    STDOUT.puts "Errors will be written to #{log_file_name}"
    logger
  end

  def log_errors(logger, errors = [], severity = nil)
    unless errors.empty?
      errors.each do |msg|
        case severity
          when :fatal
            logger.fatal(msg)
          when :error
            logger.error(msg)
          else
            logger.info(msg)
        end
      end
    end
  end

  def confirm(msg)
    STDOUT.printf "OK to " + msg + " (y/n)? "
    input = STDIN.gets.chomp.downcase
    input == "y"
  end

end