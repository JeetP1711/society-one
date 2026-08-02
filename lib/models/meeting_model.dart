class Meeting {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String venue;
  final List<String> agendaItems;
  final Map<String, bool> rsvps; // userId -> true (attending) / false (declined)

  const Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.venue,
    required this.agendaItems,
    required this.rsvps,
  });

  Meeting copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? venue,
    List<String>? agendaItems,
    Map<String, bool>? rsvps,
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      venue: venue ?? this.venue,
      agendaItems: agendaItems ?? this.agendaItems,
      rsvps: rsvps ?? this.rsvps,
    );
  }
}
