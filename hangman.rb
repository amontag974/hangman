def create_word_list
    words = File.open("5desk.txt", "r")
    word_list = words.read.split(" ").select { |word| word.length > 5 && word.length < 12 }
    words.close
    word_list
end

class Game
    attr_reader :selected_word
    attr_accessor :hidden_word

    @@guesses_left = 6
    @@letters_guessed = []

    def initialize
        word_list = create_word_list      
        @selected_word = word_list.sample.downcase
        @hidden_word = ["_"] * @selected_word.length

        self.get_game_state
        self.play_game
    end

    def get_game_state
        puts "Would you like to load a save (load) or start a new game (new)?"
        game_state = gets.chomp
        while game_state.downcase != "load" && game_state.downcase != "new"
            puts "Please type 'load' to load an existing game or 'new' to start a new game:"
            game_state = gets.chomp
        end

        if game_state.downcase == "load"
            load_save if File.file?("savefile.txt")
            puts "No previous save exists. Starting a new game" if !File.file?("savefile.txt")
        end
    end

    def save_game
        savefile = File.open("savefile.txt","w")
        savefile.puts "#{@@guesses_left}"
        savefile.puts "#{@selected_word}"
        savefile.puts "#{@hidden_word.join(" ")}"
        savefile.puts "#{@@letters_guessed.join(" ")}"
        savefile.close

    end

    def load_save
        savefile = File.open("savefile.txt","r")
        @@guesses_left = savefile.readline.to_i
        @selected_word = savefile.readline.strip
        @hidden_word = savefile.readline.split(" ")
        @@letters_guessed = savefile.readline.split(" ")
        savefile.close
    end

    def display_word
        @hidden_word.join(" ")
    end

    def letter_already_guessed?(letter)
        if @@letters_guessed.include?(letter)
            true
        else
            false
        end
    end

    def display_letters_guessed
        @@letters_guessed.join(", ")
    end

    def guess_letter
        guess = " "
        vaild_characters = "abcdefghijklmnopqrstuvwxyz".split("")
        while !vaild_characters.include?(guess) || letter_already_guessed?(guess)
            puts "Please guess a letter that hasn't been guessed "
            puts "\nLetters guessed: #{self.display_letters_guessed}\n"
            guess = gets.chomp.downcase
            if guess == "save"
                save_game
                break
            end
        end

        @@letters_guessed << guess unless guess == "save"
        guess
    end

    def amend_hidden_word(guess)
        @selected_word.split("").each_with_index do |letter,index|
            if guess == letter
                @hidden_word[index] = guess
            end       
        end
        @hidden_word
    end

    def correct_guess?(guess)
        if selected_word.include?(guess)
            puts "\n'#{guess}' is a correct guess!"
            true
        elsif guess == "save"
            puts "\nGame Saved!"
        else
            puts "\n'#{guess}' is not in the word!"
            @@guesses_left -= 1
            false
        end
    end

    def check_for_win
        unless @hidden_word.include?("_")
            true
        else
            false
        end
    end

    def play_game
        puts "Here is the incomplete word:\n #{self.display_word}"
        while @@guesses_left > 0
            break if check_for_win
            puts "\nGuesses left: #{@@guesses_left}"
            guess = guess_letter
            self.correct_guess?(guess)
            decoded_word = amend_hidden_word(guess).join(" ")
            if @hidden_word.include?("_")
                puts "\nHere is the incomplete word:\n #{self.display_word}"
                puts "------------------------"
            end
        end
        puts "You win!\nThe correct word was #{self.selected_word}. Congratulations!" unless @hidden_word.include?("_")
        puts "You're out of turns. The word was #{self.selected_word}" if @hidden_word.include?("_")
    end
end

new_game = Game.new
