class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def initialize(new_word)
    @word = new_word
    @guesses = ''
    @wrong_guesses = ''
  end

  def word
    @word
  end

  def guesses
    @guesses
  end

  def wrong_guesses
    @wrong_guesses
  end

  def guess(char)

    if char != nil
      down_char = char.downcase
    end

    if down_char.nil? or /[^A-Za-z]/.match(down_char) != nil or down_char == ''
      raise ArgumentError.new("Invalid guess.")
    end

    if @guesses.include? down_char or @wrong_guesses.include? down_char
      return false
    end

    if @word.include? char
      @guesses = @guesses + char
      return true
    else
      @wrong_guesses = @wrong_guesses + char
      return true
    end
  end

  def word_with_guesses
    @word.gsub(/[^ #{@guesses}]/, '-')
  end

  def check_win_or_lose
    if @wrong_guesses.length >= 7
      return :lose
    end

    if word_with_guesses == @word
      return :win
    end

    :play
  end
end