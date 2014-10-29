class PitchingsController < ApplicationController
  before_action :set_pitching, only: [:show, :edit, :update, :destroy]

  # GET /pitchings
  # GET /pitchings.json
  def index
    @pitchings = Pitching.all
  end

  # GET /pitchings/1
  # GET /pitchings/1.json
  def show
  end

  # GET /pitchings/new
  def new
    @pitching = Pitching.new
  end

  # GET /pitchings/1/edit
  def edit
  end

  # POST /pitchings
  # POST /pitchings.json
  def create
    @pitching = Pitching.new(pitching_params)

    respond_to do |format|
      if @pitching.save
        format.html { redirect_to @pitching, notice: 'Pitching was successfully created.' }
        format.json { render :show, status: :created, location: @pitching }
      else
        format.html { render :new }
        format.json { render json: @pitching.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pitchings/1
  # PATCH/PUT /pitchings/1.json
  def update
    respond_to do |format|
      if @pitching.update(pitching_params)
        format.html { redirect_to @pitching, notice: 'Pitching was successfully updated.' }
        format.json { render :show, status: :ok, location: @pitching }
      else
        format.html { render :edit }
        format.json { render json: @pitching.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pitchings/1
  # DELETE /pitchings/1.json
  def destroy
    @pitching.destroy
    respond_to do |format|
      format.html { redirect_to pitchings_url, notice: 'Pitching was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pitching
      @pitching = Pitching.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pitching_params
      params.require(:pitching).permit(:playerID, :yearID, :league, :teamID)
    end
end
