enum Skill { FLUTTER, DART, OTHER }

class Address {
  final String street;
  final String city;
  final String zipCode;

  const Address({
    required this.street,
    required this.city,
    required this.zipCode,
  });

  @override
  String toString() => '$street, $city $zipCode';
}

class Employee {
  final int _id;
  final String _name;
  final String _position;
  final double _baseSalary;
  final int _yearsOfExperience;
  final List<Skill> _skills;
  final Address _address;

  // Getters
  int get id => _id;
  String get name => _name;
  String get position => _position;
  double get baseSalary => _baseSalary;
  int get yearsOfExperience => _yearsOfExperience;
  List<Skill> get skills => List.unmodifiable(_skills);
  Address get address => _address;

  Employee(
      {required int id,
      required String name,
      required String position,
      required double baseSalary,
      required int yearsOfExperience,
      required List<Skill> skills,
      required Address address})
      : _id = id,
        _name = name,
        _position = position,
        _baseSalary = baseSalary,
        _yearsOfExperience = yearsOfExperience,
        _skills = List.from(skills),
        _address = address;

  // Named constructor: creates an employee with an empty skills list
  Employee.withoutSkills(
      {required int id,
      required String name,
      required String position,
      required double baseSalary,
      required int yearsOfExperience,
      required Address address})
      : _id = id,
        _name = name,
        _position = position,
        _baseSalary = baseSalary,
        _yearsOfExperience = yearsOfExperience,
        _skills = [],
        _address = address;

  // Named constructor: create from a Map (useful for JSON-like data)
  Employee.fromMap(Map<String, dynamic> m)
      : _id = m['id'] as int,
        _name = m['name'] as String,
        _position = m['position'] as String? ?? 'Employee',
        _baseSalary = (m['baseSalary'] as num).toDouble(),
        _yearsOfExperience = m['yearsOfExperience'] as int,
        _skills = (m['skills'] as List<dynamic>?)
                ?.map((s) => Skill.values.firstWhere((e) => e.name == s))
                .toList() ??
            [],
        _address = Address(
            street: m['address']['street'] as String,
            city: m['address']['city'] as String,
            zipCode: m['address']['zipCode'] as String);

  // Named constructor for mobile developers
  Employee.mobileDeveloper(
      {required int id,
      required String name,
      required double baseSalary,
      required Address address,
      String position = 'Mobile Developer',
      int yearsOfExperience = 0})
      : _id = id,
        _name = name,
        _position = position,
        _baseSalary = baseSalary,
        _yearsOfExperience = yearsOfExperience,
        _skills = [Skill.FLUTTER, Skill.DART],
        _address = address;

  double calculateTotalSalary() {
    double total = _baseSalary + (_yearsOfExperience * 2000);

    for (var skill in _skills) {
      if (skill == Skill.FLUTTER) total += 5000;
      else if (skill == Skill.DART) total += 3000;
      else total += 1000;
    }

    return total;
  }

  void addSkill(Skill skill) {
    if (!_skills.contains(skill)) {
      _skills.add(skill);
    }
  }

  @override
  String toString() {
    return 'Employee{id: $_id, name: $_name, position: $_position, '
        'experience: $_yearsOfExperience years, '
        'skills: ${_skills.map((s) => s.name).join(', ')}, '
        'address: $_address}';
  }

  void details() {
    print('Name: $_name');
    print('Position: $_position');
    print('Address: $_address');
    print('Experience: $_yearsOfExperience years');
    print('Skills: ${_skills.map((s) => s.name).join(', ')}');
    print('Total Salary: \$${calculateTotalSalary().toStringAsFixed(2)}');
    print('----------------------');
  }
}

void main() {
  // Create a sample address
  var address1 = Address(
    street: '123 Main St',
    city: 'Phnom Penh',
    zipCode: '12000'
  );

  // Create employees using different constructors
  var emp1 = Employee(
    id: 1,
    name: 'Sokea',
    position: 'Senior Developer',
    baseSalary: 40000,
    yearsOfExperience: 3,
    skills: [Skill.FLUTTER, Skill.DART],
    address: address1
  );

  var emp2 = Employee.withoutSkills(
    id: 2,
    name: 'Ronan',
    position: 'Junior Dev',
    baseSalary: 45000,
    yearsOfExperience: 5,
    address: Address(
      street: '456 Side St',
      city: 'Phnom Penh',
      zipCode: '12000'
    )
  );

  // Use regular constructor and a named constructor
  print('Initial employee states:');
  emp1.details();
  emp2.details();

  // Demonstrate adding a skill
  print('\nAfter adding DART skill to emp2:');
  emp2.addSkill(Skill.DART);
  emp2.details();

  // Demonstrate fromMap named constructor
  var emp3 = Employee.fromMap({
    'id': 3,
    'name': 'Alex',
    'position': 'QA',
    'baseSalary': 30000,
    'yearsOfExperience': 2,
    'skills': ['OTHER'],
    'address': {
      'street': '789 Test Ave',
      'city': 'Phnom Penh',
      'zipCode': '12000'
    }
  });
  print('\nEmployee created from map:');
  emp3.details();

  // Demonstrate mobileDeveloper named constructor
  var emp4 = Employee.mobileDeveloper(
    id: 4,
    name: 'Jamie',
    baseSalary: 50000,
    yearsOfExperience: 4,
    address: Address(
      street: '321 Dev Rd',
      city: 'Phnom Penh',
      zipCode: '12000'
    )
  );
  print('\nMobile developer employee:');
  emp4.details();
}