
int gridColumnsForWidth(double w) {
  if (w < 520) return 1;
  if (w < 900) return 2;
  if (w < 1280) return 3;
  if (w < 1600) return 4;
  return 5;
}
