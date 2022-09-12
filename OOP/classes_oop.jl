using ObjectOriented
@oodef mutable struct Foo
    function bar(self)::Int64
        return self.baz()
    end

    function baz(self)::Int64
        return 10
    end

    function bar_str(self)::String
        return "a"
    end
end
@oodef mutable struct Shape
    x
    y

    function new(x, y)
        @mk begin
            x = x
            y = y
        end
    end

    function position(self)
        return "($(self.x), $(self.y))"
    end
end
@oodef mutable struct Square <: Shape
    side

    function new(x, y, side)
        @mk begin
            Shape(x, y)
            side = side
        end
    end

    function area(self)
        self.x * self.y
    end
end
@oodef mutable struct Person
    name::String

    function new(name::String)
        @mk begin
            name = name
        end
    end

    function get_id(self::Person)::String
        return self.name
    end
end
@oodef mutable struct Student <: Person
    name::String
    student_number::Int64
    domain::String

    function new(name::String, student_number::Int64, domain::String = "school.student.pt")
        @mk begin
            name = name
            student_number = student_number
            domain = domain
        end
    end

    function get_id(self)
        return "$(self.name) - $(self.student_number)"
    end
end
@oodef mutable struct Worker <: Person
    name::String
    company_name::String
    hours_per_week::Int64

    function new(name::String, company_name::String, hours_per_week::Int64)
        @mk begin
            name = name
            company_name = company_name
            hours_per_week = hours_per_week
        end
    end
end
@oodef mutable struct StudentWorker <: {Student, Worker}
    is_exhausted::Bool

    function new(
        name::String,
        student_number::Int64,
        domain::String,
        company_name::String,
        hours_per_week::Int64,
        is_exhausted::Bool,
    )
        @mk begin
            Student(name, student_number, domain)
            Worker(name, company_name, hours_per_week)
            is_exhausted = is_exhausted
        end
    end
end
if abspath(PROGRAM_FILE) == @__FILE__
    f = Foo()
    b = f.bar()
    @assert(b == 10)
    c = f.bar_str()
    @assert(c == "a")
    shape = Shape(1, 3)
    square = Square(2, 4, 5)
    @assert(square.position() == "(2, 4)")
    p = Person("P")
    @assert(p.name == "P")
    @assert(p.get_id() == "P")
    s = Student("S", 111111)
    @assert(s.name == "S")
    @assert(s.student_number == 111111)
    @assert(s.domain == "school.student.pt")
    @assert(s.get_id() == "S - 111111")
    w = Worker("John", "Siemens", 35)
    @assert(w.name == "John")
    @assert(w.company_name == "Siemens")
    @assert(w.hours_per_week == 35)
    @assert(w.get_id() == "John")
    sw = StudentWorker("Timo Marcello", 1111, "school.student.pt", "Cisco", 40, true)
    @assert(sw.company_name == "Cisco")
    @assert(sw.is_exhausted == true)
    @assert(sw.name == "Timo Marcello")
    @assert(sw.student_number == 1111)
    @assert(sw.domain == "school.student.pt")
    @assert(sw.company_name == "Cisco")
    @assert(sw.hours_per_week == 40)
    @assert(sw.is_exhausted == true)
    println("OK")
end
