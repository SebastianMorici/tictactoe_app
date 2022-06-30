# PlayersController
class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :update, :destroy, :create_board]

  def index
    @players = Player.all
    render status: 200, json: { players: @players }
  end

  # 'params[]' es el hash formado por los atributos que vienen de una request
  def show
    render status: 200, json: { player: @player }
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      render status: 200, json: { player: @player }
    else
      render status: 400, json: { message: @player.errors.details }
    end
  end

  def update
    if @player.update(player_params)
      render status: 200, json: { player: @player }
    else
      render status: 400, json: { message: @player.errors.details }
    end
  end

  def destroy
    if @player.destroy
      render status: 200, json: { deleted: true }
    else
      render status: 400, json: { message: @player.errors.details }
    end
  end

  def create_board
    @board = Board.find_by(full: false)
    if @board.present?
      set_full_board
    else
      set_half_board
    end
  end

  def login
    @player = Player.find_by(name: params[:name])
    if @player.present?
      render status: 200, json: { player: @player }
    else
      render status: 404, json: { message: "Player with name: #{params[:name]} not found" }
    end
  end

  private

  # Describe que atributos va a aceptar el controlador ('strong params'). Ignora el resto.
  # Devuelve estos atributos
  def player_params
    params.require(:player).permit(:name)
  end

  def set_player
    @player = Player.find_by(id: params[:id])
    return if @player.present? # present? devuelve true si el valor no vacio ni es nil

    # Si @player.present? = false, ejecuta la siguiente linea y devuelve false. Sino devuelve true.
    render status: 404, json: { message: "Player with id: #{params[:id]} not found" }
    false
  end

  def set_full_board
    @board.playero = @player
    @board.full = true
    if @board.save
      render status: 200, json: { board: @board }
    else
      render status: 400, json: { message: @board.errors.details }
    end
  end

  def set_half_board
    @board = @player.playerx_boards.create
    if @board.save
      render status: 200, json: { board: @board, message: 'Waiting for another player' }
    else
      render status: 400, json: { message: @board.errors.details }
    end
  end
end
