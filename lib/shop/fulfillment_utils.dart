
String toMapUrl(String address) {
  final q = Uri.encodeComponent(address);
  return 'https://www.google.com/maps/search/?api=1&query=$q';
}

List<Map<String, String>> buildTimeslotsFrom(Map<String, dynamic> f) {
  final sd = (f['start_date'] ?? '').toString();
  final st = (f['start_time'] ?? '').toString();
  final ed = (f['end_date'] ?? '').toString();
  final et = (f['end_time'] ?? '').toString();
  if (sd.isEmpty && st.isEmpty && ed.isEmpty && et.isEmpty) return const [];
  final label = [sd, st, '–', ed, et].where((e) => e.toString().trim().isNotEmpty).join(' ');
  return [{'id':'slot1','label': label.trim()}];
}
