abstract class Bottle {
  void open();

  factory Bottle() {
    return CokeBottle();
  }
}

class CokeBottle implements Bottle {
 
  void open() {
    print('Coke bottle is opened');
  }
}

void main() {
  Bottle bottle = Bottle(); // Using factory constructor
  bottle.open();
}
