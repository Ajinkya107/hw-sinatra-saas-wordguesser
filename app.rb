require 'sinatra/base'
require 'sinatra/flash'
require './lib/wordguesser_game.rb'

class WordguesserApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end

  # Good examples of Sinatra syntax may be found in these two routes.
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
    # NOTE: The autograder needs the next line, so do not change it!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: The previous line must remain as it is for the autograder.

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

  # Process a guess using HangpersonGame's built-in techniques.
  # # If a guess is made more than once, set flash[:message] to "You have used that letter already."
  # # If a guess is incorrect, set flash[:message] to "Invalid prediction."
  post '/guess' do
    begin
      letter = params[:guess].to_s[0]
      guesses_before_guess = @game.guesses
      if !@game.guess(letter)
        flash[:message] = "You have already used that letter."
      elsif guesses_before_guess == @game.guesses
        flash[:message] = "Invalid guess."
      end
    rescue ArgumentError
      flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end

  # We should ultimately arrive at this route after making several guesses.
  # Use existing methods in WordguesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # You should be aware that the show.erb template anticipates using instance variables.
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    case @game.check_win_or_lose
    when :win
      redirect '/win'
    when :lose
      redirect '/lose'
    else
      erb :show # You may change/remove this line
    end
  end

  get '/win' do
    redirect '/show' if @game.check_win_or_lose == :play
    erb :win # You may change/remove this line
  end

  get '/lose' do
    redirect '/show' if @game.check_win_or_lose == :play
    erb :lose # You may change/remove this line
  end

end