def format(number, separator= '.')
    # Returns the formatted number by grouping it by 3 digits with separator
    formatted = ''
    digits = number.to_s.split('').reverse
    digits.each_with_index do |value, index|
        formatted = "#{(index + 1 < digits.size && index % 3 == 2)? separator: ''}#{value}#{formatted}"
    end
    return formatted
end

class Distributor
    # A basic money distributor class
    attr_reader :account_balance

    def initialize
        @account_balance = 5_000_000
        propose
    end

    def show_balance
        puts "Account balance: Ar #{format(@account_balance)}\n"
    end

    private

    def balanced_currency(amount, *currencies)
        currency = Hash.new(0)
        currencies.sort!
        while (amount > 0)
            for cur in currencies
                key = "c#{cur}"
                if amount >= cur
                    currency[key] += 1
                    amount -= cur
                end
            end
=begin
            if amount >= cur
                currency[:c5000] += 1
                amount -= cur
            end
            if amount >= 10000
                currency[:c10000] += 1
                amount -= 10000
            end
            if amount >= 20000
                currency[:c20000] += 1
                amount -= 20000
            end
=end
        end # End while
        # print_currency currency
        return currency # If needed, we return the number
    end

    def get_amount
        # Returns the amount to withdraw
        loop do
            puts "** Amount to withdraw **"
            5.times {|i| puts "#{i+1}) Ar #{format(50000 * (i+1))}"}
            puts '6) Custom amount'
            puts '0) Home'

            print 'Your choice: '
            choice = gets.chomp
            return if choice == '0'
            
            puts "=" * 50

            # Get choice to int
            if choice.respond_to? :to_i
                choice = choice.to_i
                case choice
                when 1..5
                    return choice * 50000
                when 6
                    amount = get_custom_amount
                    unless amount == nil
                        return amount
                    end
                else
                    puts "Invalid choice"
                end
            else
                puts "Invalid choice..."
                continue
            end
            puts "=" * 50
        end
    end

    def get_custom_amount(min= 50000)
        # gets and return custom amount
        loop do
            print "Enter the amount (minimum: #{format(min)}) or 0 to go back: "
            amount = gets.chomp
            
            return if amount == '0'

            if amount.respond_to? :to_i
                amount = amount.to_i
                return amount if amount >= min
                puts 'The amount is too low'
            else
                puts 'Invalid amount given'
                continue
            end
        end
    end

    def minimum_currency(amount, *currencies)
        currency = Hash.new(0)
        currencies.sort! { |a, b| b - a }   # Descendant sorting
        for cur in currencies
            break if amount < currencies.last
            key = "c#{cur}"
            if amount / cur != 0
                currency[key] += amount / cur
                amount %= cur
            end
        end
=begin
            if amount >= cur
                currency[:c5000] += 1
                amount -= cur
            end
            if amount >= 10000
                currency[:c10000] += 1
                amount -= 10000
            end
            if amount >= 20000
                currency[:c20000] += 1
                amount -= 20000
            end
=end
        # print_currency currency
        return currency # If needed, we return the number
    end

    def print_currency(currency)
        # Takes a currency hash and print the values in it
        puts "=" * 50
        amount = 0
        currency.each do |key, value|
            if value != 0
                puts "Ar #{format(key[1..].to_i)} * #{value}" 
                amount += value * key[1..].to_i
            end
        end
        puts "-" * 50
        puts "Total withdrawal: Ar #{format(amount)}"
        puts "-" * 50
    end

    def propose
        # Proposition in the distributor
        puts "WELCOME!"
        show_balance
        loop do
            puts '1) Withdraw money'
            puts '2) View account balance'
            puts '0) Exit'
            print 'Your choice: '
            choice = gets.chomp

            puts "=" * 50
            break if choice == '0'

            # Basic operations
            case choice
            when '1'
                # Withdrawal
                withdraw
            when '2'
                # Account balance
                show_balance
            else
                puts "Invalid choice..."
            end
            puts "=" * 50
        end

        puts "Have a nice day!"
    end

    def withdraw
        amount = nil    # Initialization

        # Choosing between balanced or minimum
        loop do
            amount = get_amount

            return if amount == nil # Go back from get_amount
            if amount > @account_balance
                puts "!!! Not enough money in your account"
                puts "=" * 50
                next
            end
            puts "* Withdrawal of Ar #{format(amount)} *"
            puts '1) Minimum currency'
            puts '2) Balanced currency'
            puts '0) Back to amount selection'
            print 'Your choice: '
            choice = gets.chomp

            case choice
            when '1'
                print_currency minimum_currency amount, 5000, 10000, 20000
                break
            when '2'
                print_currency balanced_currency amount, 5000, 10000, 20000
                break
            when '0'
            else
                puts "Invalid choice"
            end
        end

        @account_balance -= amount
        show_balance
    end
end

distributor = Distributor.new