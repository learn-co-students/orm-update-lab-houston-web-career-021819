require_relative "../config/environment.rb"
require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
attr_accessor :id, :name, :grade

def initialize(id = nil, name, grade)
  @id = id
  @name = name
  @grade = grade
end

def self.create_table
  DB[:conn].execute(
    "CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
      )"
    )
end

def self.drop_table
  DB[:conn].execute(
    "DROP TABLE students"
    )
end

def save
  if self.id
     self.update
  else
    DB[:conn].execute(
    "INSERT INTO students(name, grade) VALUES (?,?)",
    [self.name, self.grade]
    )
    self.id = DB[:conn].last_insert_row_id
   
  end
end

def update
  DB[:conn].execute("
    UPDATE students SET name = ?, grade = ? WHERE id = ?",
    [self.name, self.grade, self.id]
    )
end

def self.create(name, grade)
  student =  Student.new(name, grade)
  student.save
end

def self.new_from_db(student)
  Student.new(student[0], student[1], student[2])
end

def self.find_by_name(name)
  results = DB[:conn].execute(
    "SELECT * FROM students WHERE name = ?",
    [name]
    )
  self.new_from_db(results[0])
end

end
