# BoardsController
class BoardsController < ApplicationController
  before_action :set_board, only: [:destroy, :play, :refresh]
  before_action :check_turn, only: [:play]
  before_action :position_available, only: [:play]

  def index
    @boards = Board.all
    render status: 200, json: { boards: @boards }
  end

  def destroy
    if @board.destroy
      render status: 200, json: { deleted: true }
    else
      render status: 400, json: { message: @board.errors.details }
    end
  end

  def play
    if @board.winner == 'pending'
      state = @board.state.split(',')
      state[params[:index]] = @board.turn
      @board.state = state.join(',')
      @board.winner = check_winner(@board.turn)
      switch_turn
      if @board.save
        render status: 200, json: { board: @board }
      else
        render status: 400, json: { message: @board.errors.details }
      end
    else
      render status: 200, json: { board: @board }
    end
  end

  def refresh
    render status: 200, json: { board: @board }
  end

  private

  # 0 1 2
  # 3 4 5
  # 6 7 8
  @@win_array = [[0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 4, 8], [2, 4, 6]]

  def switch_turn
    @board.turn = @board.turn == 'x' ? 'o' : 'x'
  end

  def check_turn
    if params[:player_id] == @board.playerx_id && @board.turn == 'o' ||
       params[:player_id] == @board.playero_id && @board.turn == 'x'
      render status: 200, json: { board: @board }
    else
      true
    end
  end

  def check_winner(turn)
    state = @board.state.split(',')
    empty_cells = 0
    @@win_array.each do |win_combination|
      count = 0
      win_combination.each do |cell|
        if state[cell] == turn
          count += 1
        elsif state[cell] == ' '
          empty_cells += 1
        end
      end
      return turn if count == 3
    end
    return 'draw' if empty_cells == 0

    'pending'
  end

  def position_available
    return if @board.state.split(',')[params[:index]] == ' '

    render status: 200, json: { board: @board }
    false
  end

  def change_state(index, turn); end

  def set_board
    @board = Board.find_by(id: params[:id])
    return if @board.present?

    render status: 404, json: { message: "Board with id: #{params[:id]} not found" }
    false
  end

  def board_params
    params.require(:board).permit(:state, :player_id, :index)
  end
end

# "one,two,three,four".split(',')
# ["one","two","three","four"]
# ["one","two","three","four"].join(',')
# "one,two,three,four"
# x x o
# o x x
# x o o
