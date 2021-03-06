class Student < User
  scope :recurring_active, -> { where(recurring_active: true) }
  default_scope { order(:name) }

  validates :plan_id, presence: true
  validates :cohort_id, presence: true
  validate :primary_payment_method_belongs_to_student

  belongs_to :plan
  belongs_to :cohort
  has_many :bank_accounts
  has_many :credit_cards
  has_many :payments
  has_many :attendance_records
  has_many :submissions
  has_many :payment_methods
  has_many :ratings
  has_many :internships, through: :ratings
  belongs_to :primary_payment_method, class_name: 'PaymentMethod'
  has_many :signatures

  def update_close_io
    if close_io_lead_exists? && enrollment_complete?
      id = close_io_client.list_leads('email:' + email).data.first.id
      close_io_client.update_lead(id, { status: 'Enrolled', 'custom.amount_paid': total_paid })
    elsif !close_io_lead_exists?
     raise "The Close.io lead for #{email} was not found."
    end
  end

  def signed?(signature_model)
    if signature_model.nil?
      true
    else
      signatures.where(type: signature_model, is_complete: true).count == 1
    end
  end

  def signed_main_documents?
    signed?(CodeOfConduct) && signed?(RefundPolicy) && signed?(EnrollmentAgreement)
  end

  def stripe_customer
    if stripe_customer_id
      customer = Stripe::Customer.retrieve(stripe_customer_id)
    else
      customer = Stripe::Customer.create(description: email)
      update(stripe_customer_id: customer.id)
      customer
    end
  end

  def payment_methods_primary_first_then_pending
    (payment_methods.not_verified_first - [primary_payment_method]).unshift(primary_payment_method).compact
  end

  def upfront_payment_due?
    plan.upfront_amount > 0 && payments.without_failed.count == 0
  end

  def recurring_amount_with_fees
    plan.recurring_amount + primary_payment_method.calculate_fee(plan.recurring_amount)
  end

  def upfront_amount_with_fees
    plan.upfront_amount + primary_payment_method.calculate_fee(plan.upfront_amount)
  end

  def ready_to_start_recurring_payments?
    plan.recurring_amount > 0 && !recurring_active && !upfront_payment_due?
  end

  def total_paid
    payments.without_failed.sum(:amount)
  end

  def signed_in_today?
    attendance_records.today.exists?
  end

  def signed_out_today?
    if signed_in_today?
      attendance_records.today.first.signed_out_time != nil
    end
  end

  def next_payment_date
    payments.without_failed.last.created_at + 1.month if recurring_active
  end

  def make_upfront_payment
    payments.create(amount: plan.upfront_amount, payment_method: primary_payment_method)
  end

  def class_in_session?
    cohort.start_date <= Time.zone.now.to_date && cohort.end_date >= Time.zone.now.to_date
  end

  def class_over?
    Time.zone.now.to_date > cohort.end_date
  end

  def start_recurring_payments
    payment = payments.create(amount: plan.recurring_amount, payment_method: primary_payment_method)
    update!(recurring_active: true) if payment.persisted?
    payment
  end

  def on_time_attendances
    attendance_records.where(tardy: false, left_early: false).count
  end

  def tardies
    attendance_records.where(tardy: true).count
  end

  def absences
    cohort.number_of_days_since_start - attendance_records.count
  end

  def find_rating(internship)
    ratings.where(internship_id: internship.id).first
  end

  def self.find_students_by_interest(internship, interest_level)
    internship.students.select { |student| student.try(:find_rating, internship).try(:interest) == interest_level }
  end

  def left_earlies
    attendance_records.where(left_early: true).count
  end

  def internships_sorted_by_interest
    cohort.internships_sorted_by_interest(self)
  end

private
  def close_io_lead_exists?
    lead = close_io_client.list_leads('email:' + email)
    lead.total_results == 1
  end

  def enrollment_complete?
    signatures.where(is_complete: true).count > 2 && total_paid > 0
  end

  def close_io_client
    @close_io_client ||= Closeio::Client.new(ENV['CLOSE_IO_API_KEY'], false)
  end

  def primary_payment_method_belongs_to_student
    if primary_payment_method && primary_payment_method.student != self
      errors.add(:primary_payment_method, 'must belong to you.')
    end
  end
end
