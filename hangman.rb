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
            puts "Please guess a letter that hasn't been guessed: "
            guess = gets.chomp.downcase
        end
        @@letters_guessed << guess
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
        else
            puts "\n'#{guess}' is not the word!"
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
                puts "\nLetters guessed: #{self.display_letters_guessed}"
                puts "------------------------"
            end
        end
        puts "You win!\nThe correct word was #{self.selected_word}. Congratulations!" unless @hidden_word.include?("_")
        puts "You're out of turns. The word was #{self.selected_word}" if @hidden_word.include?("_")
    end
end

new_game = Game.new
new_game.play_game
