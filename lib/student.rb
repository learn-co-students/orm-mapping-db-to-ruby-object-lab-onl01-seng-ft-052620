class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    self.new.tap do |new_student|
      new_student.id = row[0]
      new_student.name = row[1]
      new_student.grade = row[2]
    end
  end

  def self.student_ary_from_sql(sql, *args)
    DB[:conn].execute(sql, *args).map{|row| new_from_db(row)}
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students;"
    student_ary_from_sql(sql)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ? LIMIT 1
    SQL

    new_from_db(DB[:conn].execute(sql, name).first)
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9;"
    student_ary_from_sql(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12;"
    student_ary_from_sql(sql)
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10 LIMIT ?
    SQL
    student_ary_from_sql(sql, x)
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10;"
    student_ary_from_sql(sql).first
  end

  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students WHERE grade = ?"
    student_ary_from_sql(sql, x)
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
