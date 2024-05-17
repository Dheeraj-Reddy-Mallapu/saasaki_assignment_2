extension DateUtil on DateTime {
  String toDateString() =>
      '${day.toString().length == 1 ? '0$day' : day}-${month.toString().length == 1 ? '0$month' : month}-$year, ${hour.toString().length == 1 ? '0$hour' : hour}:${minute.toString().length == 1 ? '0$minute' : minute}';
}
