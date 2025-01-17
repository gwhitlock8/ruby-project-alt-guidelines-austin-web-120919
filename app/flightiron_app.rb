class FlightironApp
    attr_reader :current_user

    prompt = TTY::Prompt.new

    def self.start
        puts "
                                            |
                                            |
                                            |
                                          .-'-.
                                         ' ___ '
                               ---------'  .-.  '---------
               _________________________'  '-'  '_________________________
                ''''''-|---|--/    \==][^',_m_,'^][==/    \--|---|-''''''
                              \    /  ||/   H   \||  \    /
                               '--'   OO   O|O   OO   '--'".green.bold
        self.login
        self.call_method
    end

    def self.login
        prompt = TTY::Prompt.new
        puts "Greetings. Welcome to the flightiron app!".yellow
        username = prompt.ask("Please enter your username: ".green.bold)
        User.find_by(username: username) ? @current_user = User.verify_password(username) : @current_user = User.create_account(username)
        print "Hello".light_blue
        print " #{@current_user.username}".blue.bold
        puts "!!!!!!".light_blue
    end

    def self.menu
        prompt = TTY::Prompt.new
        choices = ["Search for Flights","View Purchased Tickets","Update User Profile","Cancel Purchased Flight","Close Flightiron"]
        prompt.select("Choose an action: ", choices)
    end

    def self.format_date
        prompt = TTY::Prompt.new
        month = prompt.ask('Please enter month of travel:') do |q|
            q.validate /0[1-9]|1[0-2]/
        end
        day = prompt.ask('Please enter day of travel:') do |q|
            q.validate /0[1-9]|1[0-9]|2[0-9]|3[0-1]/
        end
        "2020-#{month}-#{day}"
    end

    def self.display_flights(flights)
        table_data = []
        flights.each_with_index do |flight, index|
            table_data << {"Flight ID" => index + 1, "Date" => flight[:departure_date], "Departure Location" => flight[:departure_location], "Arrival Location" => flight[:arrival_location], "Airline" => flight[:airline],"Departure Time" => flight[:departure_time]}
        end

        Formatador.display_table(table_data)

        self.select_flight(flights)
    end

    def self.select_flight(flights)
        prompt = TTY::Prompt.new
        choice = prompt.ask("Please select a Flight ID to confirm ticket, 'Q' to quit: ".cyan.bold)
        case choice
        when 'q' || 'Q'
            puts "Returning to main menu...".green
            self.call_method   
        else
            flight = flights[choice.to_i - 1]
            new_ticket = Ticket.create(user_id: @current_user.id, flight_id: flight.id)
            @current_user.tickets << new_ticket
            flight.tickets << new_ticket
        end
    end

    def self.call_method
        prompt = TTY::Prompt.new
        choice = self.menu
        case choice
        when "Search for Flights"
            destination = prompt.ask("Please enter destination: ".green.bold)
            destination.capitalize
            date = format_date
            Flight.find_flights(destination,date,@current_user)
            self.call_method
        when "View Purchased Tickets"
           Ticket.print(@current_user.id)
           self.call_method
        when "Update User Profile"
            @current_user.user_update
            self.call_method
        when "Cancel Purchased Flight"
            Ticket.cancel_ticket(@current_user.id)
            self.call_method
        when "Close Flightiron"
           puts "Closing app....".red.bold
           puts "Thank you for using the Flightiron app. Have a nice day!".green.bold
        else 
           puts "Invalid Selection. Try again!".red.bold
           self.call_method
        end
    end

end