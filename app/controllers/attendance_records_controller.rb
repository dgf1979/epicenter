class AttendanceRecordsController < ApplicationController
  authorize_resource

  def index
    @students = current_admin.current_cohort.students.order(:name)
  end

  def create
    @attendance_record = AttendanceRecord.new(attendance_record_params)
    @students = current_admin.current_cohort.students.order(:name)
    respond_to do |format|
      if @attendance_record.save
        flash[:notice] = "Welcome #{@attendance_record.student.name}"
        flash[:secure] =  view_context.link_to("Not you?",
                          attendance_record_path(@attendance_record),
                          data: {method: :delete})
        format.html { redirect_to attendance_path }
        format.js { @student = @attendance_record.student }
      else
        flash[:alert] = "Something went wrong: " + @attendance_record.errors.full_messages.join(", ")
        format.html { redirect_to attendance_path }
        format.js {}
      end
    end
  end

  def update
    @attendance_record = AttendanceRecord.find(params[:id])
    @students = current_admin.current_cohort.students.order(:name)
    respond_to do |format|
      if @attendance_record.update(attendance_record_params)
        flash[:notice] = "#{@attendance_record.student.name} successfully updated."
        format.html { redirect_to attendance_path }
        format.js { @student = @attendance_record.student }
      else
        flash[:alert] = "Something went wrong: " + @attendance_record.errors.full_messages.join(", ")
        format.html { redirect_to attendance_path }
        format.js { @student = @attendance_record.student }
      end
    end
  end

  def destroy
    @attendance_record = AttendanceRecord.find(params[:id])
    @attendance_record.destroy
    redirect_to attendance_path, alert: "Attendance record has been deleted."
  end

private

  def attendance_record_params
    params.require(:attendance_record).permit(:signing_out, :student_id)
  end
end
