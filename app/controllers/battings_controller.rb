class BattingsController < ApplicationController
  before_action :set_batting, only: [:show, :edit, :update, :destroy]

  # GET /battings
  # GET /battings.json
  def index
    @battings = Batting.all
  end

  # GET /battings/1
  # GET /battings/1.json
  def show
  end

  # GET /battings/new
  def new
    @batting = Batting.new
  end

  # GET /battings/1/edit
  def edit
  end

  # POST /battings
  # POST /battings.json
  def create
    @batting = Batting.new(batting_params)

    respond_to do |format|
      if @batting.save
        format.html { redirect_to @batting, notice: 'Batting was successfully created.' }
        format.json { render :show, status: :created, location: @batting }
      else
        format.html { render :new }
        format.json { render json: @batting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /battings/1
  # PATCH/PUT /battings/1.json
  def update
    respond_to do |format|
      if @batting.update(batting_params)
        format.html { redirect_to @batting, notice: 'Batting was successfully updated.' }
        format.json { render :show, status: :ok, location: @batting }
      else
        format.html { render :edit }
        format.json { render json: @batting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /battings/1
  # DELETE /battings/1.json
  def destroy
    @batting.destroy
    respond_to do |format|
      format.html { redirect_to battings_url, notice: 'Batting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batting
      @batting = Batting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def batting_params
      params.require(:batting).permit(:playerID, :yearID, :league, :teamID, :G, :AB, :R, :H, :twoB, :threeB, :HR, :RBI, :SB, :CS)
    end
end
