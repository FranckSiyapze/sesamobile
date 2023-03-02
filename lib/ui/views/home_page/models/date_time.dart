class DateTimeA {
  final String date, day;

  DateTimeA(this.date, this.day);

  static List<DateTimeA> dummyList() {
    List<DateTimeA> list = [];

    list.add(DateTimeA("01", "Sun"));
    list.add(DateTimeA("02", "Mon"));
    list.add(DateTimeA("03", "Tue"));
    list.add(DateTimeA("04", "Wed"));
    list.add(DateTimeA("05", "Thu"));
    list.add(DateTimeA("06", "Fri"));
    list.add(DateTimeA("07", "Sat"));
    list.add(DateTimeA("08", "Sun"));
    list.add(DateTimeA("09", "Mon"));
    list.add(DateTimeA("10", "Tue"));

    return list;
  }
}
