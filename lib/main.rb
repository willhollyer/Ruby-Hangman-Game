
class NewGame
  def initialize
    @word_bank = File.read("5desk.txt").split("\r\n")

    @target_array = @word_bank.filter do |word|
      word.length >= 5 && word.length <= 12
    end

    @selected_random_word = @target_array.sample
    @display = @selected_random_word.split(//).map {|char| char = "_" }.join(" ")
    
    @number_of_remaining_turns = 10
    @guessed = []

    puts "Thank you for choosing to play Hangman. A random word has been selected for you to guess. You now have #{@number_of_remaining_turns} turns to guess the selected word."
  end

  def display_correct_guesses
    puts "\nHere is your word -->   #{@display}"
  end

  def play_game
    begin
        show_guessed
        display_correct_guesses
        puts "Please enter a letter, or type save to save progress: " 
        user_input = gets.chomp
        return 'save' if user_input == "save"

        raise "Invalid input: #{user_input}" unless /[[:alpha:]]/.match(user_input) && user_input.length == 1 
        raise "You've already guessed that letter!" if @guessed.include?(user_input)

        submit_user_input(user_input.downcase)
    rescue StandardError => e
      puts e.to_s
      retry
    end
  end

  def game_over?
    
    if @display.split(' ').join('') == @selected_random_word
      puts "\nCongratulations! You win! The word was #{@selected_random_word}."
      true
    elsif @number_of_remaining_turns == 0
      puts "\nYou lose! The word was #{@selected_random_word}"
      true
    end
  end

  def submit_user_input(letter)
    if @selected_random_word.include?(letter)
      @guessed.push(letter)
      append_correct_guess(letter)
      puts "\nGreat guess!"
    else
      @guessed.push(letter)
      @number_of_remaining_turns -= 1
      puts "Incorrect guess! You have #{@number_of_remaining_turns} turns remaining."
    end
  end

  def show_guessed
    puts "\nYou have guessed: #{@guessed}"
  end

  private

  def append_correct_guess(character)
    @selected_random_word.split('').each_with_index do |char, index|
      if char == character
        @display = @display.split(' ')
        @display[index] = char
        @display = @display.join(' ')
      end
    end
  end
end

