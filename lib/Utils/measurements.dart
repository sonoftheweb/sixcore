class Measurement {
  static String cmToInchAndFeetText(double cm) {
    double meter = cm / 100;
    double inch = (meter * 39.37);
    double ft1 = inch / 12;
    int n = ft1.toInt();
    double in1 = ft1 - n;
    double in2;
    in2 = in1 * 12;
    return "${n.round()} ft ${in2.round()} in";
  }
}
