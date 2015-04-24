class InternshipsController < ApplicationController
  def index
    @cohort = Cohort.find(params[:cohort_id])
    if current_student
      @internships = @cohort.internships_sorted_by_interest(current_student)
    else
      @internships = @cohort.internships
    end
  end

  def show
    @internship = Internship.find(params[:id])
    @company = @internship.company
    if current_student
      if current_student.ratings.where(internship_id: @internship.id).any?
        @rating = current_student.find_rating(@internship)
      else
        @rating = Rating.new
      end
    end
  end

  def new
    @cohort = Cohort.find(params[:cohort_id])
    @internship = Internship.new
  end

  def create
    @cohort = Cohort.find(params[:cohort_id])
    @internship = @cohort.internships.new(internship_params)

    if @internship.save
      flash[:notice] = "Internship added"
      redirect_to cohort_internships_path(@cohort)
    else
      render :new
    end
  end

  def edit
    @cohort = Cohort.find(params[:cohort_id])
    @internship = Internship.find(params[:id])
  end

  def update
    @cohort = Cohort.find(params[:cohort_id])
    @internship = Internship.find(params[:id])
    if @internship.update(internship_params)
      flash[:notice] = 'Internship updated'
      redirect_to cohort_internships_path(@cohort)
    else
      render :edit
    end
  end

  def destroy
    @cohort = Cohort.find(params[:cohort_id])
    @internship = Internship.find(params[:id])
    @internship.destroy
    flash[:alert] = "Internship deleted"
    redirect_to cohort_internships_path(@cohort)
  end


  private

    def internship_params
      params.require(:internship).permit(:company_id, :description, :ideal_intern, :clearance_required, :clearance_description)
    end

end