require_relative 'main'
require 'yaml'

def save_game(current_game)
  filename = prompt_name
  return false unless filename
  dump = YAML.dump(current_game)
  datafile = File.new(File.join(Dir.pwd, "/saved/#{filename}.yaml"), "w")
   datafile.puts "#{dump}"
   datafile.close
  true
end

def prompt_name
  begin
    filenames = Dir.glob('saved/*').map {|file| file[(file.index('/') + 1)...(file.index("."))]}
    puts "Enter name for saved game."
    filename = gets.chomp
    raise "#{filename} already exists." if filenames.include?(filename)
    filename
  rescue => exception
    puts "Are you sure you want to rewrite the file? (Yes/No)"
    answer = gets[0].downcase
    until answer == 'y' || answer == 'n'
      puts "Invalid input. Are you sure you want to rewrite the file? (Yes/No)"
      answer = gets[0].downcase
    end
    answer == 'y' ? filename : nil
  end
end

def load_game
  filename = choose_game
  saved = File.open(File.join(Dir.pwd, filename), 'r')
  loaded_game = YAML.load(saved)
  saved.close
  loaded_game
end

def choose_game
  begin
    puts "Here are the currently saved games. Please select which game you'd like to load."
    filenames = filenames = Dir.glob('saved/*').map { |file| file[(file.index('/') + 1)...(file.index('.'))]}
    puts filenames
    filename = gets.chomp
    raise "#{filename} does not exist." unless filenames.include?(filename)
    puts "#{filename} loaded..."
    puts "/saved/#{filename}.yaml"
  rescue => exception
    puts exception
    retry
  end
end

puts "Welcome to Hangman. Would you like to: 1) Start a new game."
puts "                                       2) Load a saved game."

game_choice = gets.chomp

until game_choice == "1" || game_choice == "2"
  puts "Invalid input. Please enter 1 or 2."
  game_choice = gets.chomp
end

game = game_choice == '1' ? NewGame.new : load_game


until game.game_over? 
  if game.play_game == 'save'
    if save_game(game)
      puts "Your game has been successfull saved!"
      break
    end   
  end
end

#save is now working. Load game is not working now. LAST STEP.