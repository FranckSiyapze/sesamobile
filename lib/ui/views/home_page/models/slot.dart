class Slot {
  final String time;

  Slot(this.time);

  static List<String> morningList() {
    List<String> list = [];

    list.add('08:00');
    list.add('09:00');
    list.add('10:00');
    list.add('11:00');

    return list;
  }

  static List<String> afternoonList() {
    List<String> list = [];

    list.add('12:00');
    list.add('13:00');
    list.add('14:00');
    list.add('15:00');
    list.add('16:00');
    list.add('17:00');
    list.add('18:00');
    return list;
  }

  static List<String> eveningList() {
    List<String> list = [];

    list.add('07:00 am');
    list.add('07:20 am');
    list.add('07:40 am');
    list.add('08:00 am');
    list.add('08:20 am');
    return list;
  }
}
