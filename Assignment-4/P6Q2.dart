class House {
  int id;
  String name;
  double price;

  House(this.id, this.name, this.price);

  void display() {
    print('ID: $id, Name: $name, Price: \$${price}');
  }
}

void main() {
  List<House> houses = [
    House(1, 'Green Villa', 1200000),
    House(2, 'Blue Cottage', 950000),
    House(3, 'Sunset Home', 1500000),
  ];

  for (var house in houses) {
    house.display();
  }
}
