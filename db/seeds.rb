#Payment Plans

plans = [
  ["Spring 2014 loan", 0, 625_00, 5000_00],
  ["Summer 2014 loan", 0, 600_00, 5000_00],
  ["Winter 2015 loan", 200_00, 600_00, 5000_00],
  ["Winter 2015 up-front", 3400_00, 0, 3400_00]
]

plans.each do |name, upfront_amount, recurring_amount, total_amount|
  Plan.create(name: name, upfront_amount: upfront_amount, recurring_amount: recurring_amount, total_amount: total_amount)
end


#Cohorts / Classes

cohorts = [
  ["Spring 2014", Date.parse("January 17, 2014"), Date.parse("January 18, 2014")],
  ["Summer 2014", Date.parse("January 17, 2014"), Date.parse("January 18, 2014")],
  ["Winter 2015", Date.parse("January 17, 2014"), Date.parse("January 18, 2014")],
]

cohorts.each do |description, start_date, end_date|
  Cohort.create(description: description, start_date: start_date, end_date: end_date)
end


#Admin
Admin.create({ name: "Admin One", email: "admin@site.com", cohort_id: 3, password: "password" })

#Students
students = ["Ava", "Ben", "Charlene", "Dan", "Edgar", "Fern", "Garret", "Han",
            "Ingrid", "Jasmine", "Keith", "Lewis", "Modani", "Nemo", "Otis",
            "Peter", "Queen", "Rooster", "Stan", "Tig", "Una", "Vanessa", "Wen",
            "Xuxu", "Yennifer", "Zooey"]

students.each do |student|
  User.create({ name: student, email: "#{student}@site.com", cohort_id: 3, current_cohort_id: 3, password: "password", type: "Student", plan_id: 4 })
end
