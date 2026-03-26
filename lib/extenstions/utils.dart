class Utils {

  static DateTime currentTime = DateTime.now();

  static String buildDateString(DateTime messageDate){
    String dateString = "";
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    dateString += "${twoDigits(messageDate.hour)}:${twoDigits(messageDate.minute)}";

    if (currentTime.year == messageDate.year) {
      if (currentTime.day == messageDate.day) {
        return dateString;
      }
      else if  (currentTime.day == messageDate.day - 1) {
        dateString += " Yesterday";
      }
      else {
        dateString += " ${messageDate.month}/${messageDate.day}";
      }
    }
    else {
      dateString += " ${messageDate.month}/${messageDate.day}/${messageDate.year}";
    }

    return dateString;
  }

}