require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_accessor :id, :name, :grade

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    if self.id
      self.update
    else
    DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

  def self.find_by_name(name)
    result = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)
    found_student = Student.new(result[0][1], result[0][2], result[0][0])
  end

  def update
    DB[:conn].execute("UPDATE students SET name=?, grade=? WHERE id =?", self.name, self.grade, self.id)
    self.id
  end

  def self.new_from_db(row)
    result = DB[:conn].execute("SELECT * FROM students WHERE id = #{row[0]}")
    new_student = Student.new(result[0][1], result[0][2], result[0][0])
  end


  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
