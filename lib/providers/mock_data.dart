import '../models/user_model.dart';
import '../models/society_model.dart';
import '../models/visitor_model.dart';
import '../models/announcement_model.dart';
import '../models/meeting_model.dart';
import '../models/maintenance_model.dart';
import '../models/amenity_model.dart';
import '../models/complaint_model.dart';
import '../models/noc_model.dart';
import '../models/directory_model.dart';

class MockData {
  // Pre-seeded Users
  static const List<AppUser> preseededUsers = [
    AppUser(
      id: 'u-1',
      username: 'admin',
      fullName: 'Vikramaditya Rao',
      email: 'admin@societyone.com',
      phone: '+91 98765 00001',
      role: UserRole.admin,
      societyName: 'All Societies System',
    ),
    AppUser(
      id: 'u-2',
      username: 'secretary',
      fullName: 'Suresh Mehta',
      email: 'secretary@greenvalley.org',
      phone: '+91 98765 00002',
      role: UserRole.secretary,
      flatNumber: 'C-302',
      societyName: 'Green Valley CHS',
    ),
    AppUser(
      id: 'u-3',
      username: 'rajesh',
      fullName: 'Rajesh Sharma',
      email: 'rajesh.sharma@example.com',
      phone: '+91 98765 11111',
      role: UserRole.member,
      flatNumber: 'A-101',
      societyName: 'Green Valley CHS',
    ),
    AppUser(
      id: 'u-4',
      username: 'priya',
      fullName: 'Priya Patel',
      email: 'priya.patel@example.com',
      phone: '+91 98765 22222',
      role: UserRole.member,
      flatNumber: 'B-201',
      societyName: 'Green Valley CHS',
    ),
  ];

  // Pre-seeded Societies
  static final List<Society> initialSocieties = [
    Society(
      id: 's-1',
      name: 'Green Valley CHS',
      registrationNumber: 'REG-MUM-2018-9942',
      address: 'Plot 42, Sector 15, Powai, Mumbai - 400076',
      totalFlats: 120,
      secretaryName: 'Suresh Mehta',
      contactPhone: '+91 98765 00002',
      status: SocietyStatus.approved,
      registrationDate: DateTime.now().subtract(const Duration(days: 400)),
    ),
    Society(
      id: 's-2',
      name: 'Sunrise Heights CHS',
      registrationNumber: 'REG-PUN-2022-1104',
      address: 'Baner Road, near Westend Mall, Pune - 411045',
      totalFlats: 80,
      secretaryName: 'Anita Deshmukh',
      contactPhone: '+91 98220 12345',
      status: SocietyStatus.approved,
      registrationDate: DateTime.now().subtract(const Duration(days: 120)),
    ),
    Society(
      id: 's-3',
      name: 'Palm Grove Residency',
      registrationNumber: 'REG-BLR-2024-8831',
      address: 'Outer Ring Road, Marathahalli, Bengaluru - 560037',
      totalFlats: 150,
      secretaryName: 'Karthik Raja',
      contactPhone: '+91 99000 87654',
      status: SocietyStatus.pending,
      registrationDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // Pre-seeded Visitors
  static final List<VisitorEntry> initialVisitors = [
    VisitorEntry(
      id: 'v-1',
      visitorName: 'Ramesh Kumar (Amazon)',
      phone: '+91 98111 22334',
      purpose: 'Package Delivery',
      expectedDateTime: DateTime.now().add(const Duration(hours: 2)),
      vehicleNo: 'MH-02-CD-4512',
      flatNumber: 'A-101',
      requestedBy: 'Rajesh Sharma',
      status: VisitorStatus.pending,
      passCode: 'GV-2026-9812',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    VisitorEntry(
      id: 'v-2',
      visitorName: 'Amit Verma (Guest)',
      phone: '+91 98222 33445',
      purpose: 'Family Visit',
      expectedDateTime: DateTime.now().add(const Duration(hours: 4)),
      vehicleNo: 'MH-04-AB-9900',
      flatNumber: 'B-201',
      requestedBy: 'Priya Patel',
      status: VisitorStatus.approved,
      passCode: 'GV-2026-1044',
      approvedBy: 'Suresh Mehta',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    VisitorEntry(
      id: 'v-3',
      visitorName: 'Sunil Service Technician',
      phone: '+91 98333 44556',
      purpose: 'AC Maintenance',
      expectedDateTime: DateTime.now().subtract(const Duration(hours: 1)),
      vehicleNo: 'MH-03-EF-1234',
      flatNumber: 'A-101',
      requestedBy: 'Rajesh Sharma',
      status: VisitorStatus.denied,
      passCode: 'GV-2026-0081',
      approvedBy: 'Suresh Mehta',
      denyReason: 'Unannounced technician entry restricted after 7 PM',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  // Pre-seeded Announcements
  static final List<Announcement> initialAnnouncements = [
    Announcement(
      id: 'a-1',
      title: 'Emergency Water Supply Interruption',
      content:
          'Due to main pipeline repair works on Municipal Road, water supply will be suspended tomorrow (Monday) from 10:00 AM to 3:00 PM. Please store sufficient water in advance.',
      priority: PriorityLevel.urgent,
      category: NoticeCategory.emergency,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      authorName: 'Suresh Mehta (Secretary)',
      isPinned: true,
    ),
    Announcement(
      id: 'a-2',
      title: 'Annual General Body Meeting (AGM 2026)',
      content:
          'Notice is hereby given for the Annual General Body Meeting scheduled for Sunday at 10:30 AM in the Clubhouse Auditorium. Mandatory attendance for flat owners.',
      priority: PriorityLevel.high,
      category: NoticeCategory.general,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      authorName: 'Management Committee',
      isPinned: true,
    ),
    Announcement(
      id: 'a-3',
      title: 'Ganesh Utsav Festival Fund Drive',
      content:
          'Contributions for this year\'s Grand Ganesh Utsav celebration are now open. Target collection: ₹1,50,000. Suggested contribution per flat: ₹2,500.',
      priority: PriorityLevel.medium,
      category: NoticeCategory.event,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      authorName: 'Cultural Committee',
    ),
  ];

  // Pre-seeded Meetings
  static final List<Meeting> initialMeetings = [
    Meeting(
      id: 'm-1',
      title: 'Annual General Body Meeting (AGM 2026)',
      description:
          'Discussion on Annual Financial Audit, Lift Overhaul Project, Solar Panel Installation, and Election of Committee Members.',
      dateTime: DateTime.now().add(const Duration(days: 5, hours: 10)),
      venue: 'Clubhouse Main Hall',
      agendaItems: [
        'Read and confirm minutes of last AGM',
        'Approval of audited accounts for FY 2025-26',
        'Proposal for Terrace Solar Rooftop Installation',
        'Security Vendor Review & Renewal',
        'Open forum & Q/A with Secretary',
      ],
      rsvps: {
        'u-3': true,
        'u-4': false,
      },
    ),
  ];

  // Pre-seeded Maintenance Dues
  static final List<MaintenanceDue> initialMaintenance = [
    MaintenanceDue(
      id: 'm-due-1',
      flatNumber: 'A-101',
      ownerName: 'Rajesh Sharma',
      monthYear: 'August 2026',
      amount: 3500.0,
      status: PaymentStatus.pending,
      dueDate: DateTime(2026, 8, 15),
    ),
    MaintenanceDue(
      id: 'm-due-2',
      flatNumber: 'B-201',
      ownerName: 'Priya Patel',
      monthYear: 'August 2026',
      amount: 3500.0,
      status: PaymentStatus.paid,
      dueDate: DateTime(2026, 8, 15),
      paidDate: DateTime(2026, 8, 1),
      transactionRef: 'UPI/609214708912/SUCCESS',
    ),
    MaintenanceDue(
      id: 'm-due-3',
      flatNumber: 'A-101',
      ownerName: 'Rajesh Sharma',
      monthYear: 'July 2026',
      amount: 3500.0,
      status: PaymentStatus.paid,
      dueDate: DateTime(2026, 7, 15),
      paidDate: DateTime(2026, 7, 10),
      transactionRef: 'UPI/508112003481/SUCCESS',
    ),
    MaintenanceDue(
      id: 'm-due-4',
      flatNumber: 'C-302',
      ownerName: 'Suresh Mehta',
      monthYear: 'August 2026',
      amount: 3500.0,
      status: PaymentStatus.paid,
      dueDate: DateTime(2026, 8, 15),
      paidDate: DateTime(2026, 8, 2),
      transactionRef: 'NETBANK/881244091/SUCCESS',
    ),
    MaintenanceDue(
      id: 'm-due-5',
      flatNumber: 'D-404',
      ownerName: 'Sunita Rao',
      monthYear: 'July 2026',
      amount: 3500.0,
      status: PaymentStatus.overdue,
      dueDate: DateTime(2026, 7, 15),
    ),
  ];

  // Pre-seeded Festival Funds
  static final List<FestivalFund> initialFestivalFunds = [
    FestivalFund(
      id: 'ff-1',
      title: 'Ganesh Utsav & Cultural Nights 2026',
      description:
          '10-day celebration including Visarjan Procession, Mahaprasad, Kids Talent Show & Musical Evening.',
      targetAmount: 150000.0,
      collectedAmount: 92500.0,
      endDate: DateTime.now().add(const Duration(days: 20)),
      contributions: [
        FundContribution(
          id: 'fc-1',
          flatNumber: 'B-201',
          contributorName: 'Priya Patel',
          amount: 2500.0,
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        FundContribution(
          id: 'fc-2',
          flatNumber: 'C-302',
          contributorName: 'Suresh Mehta',
          amount: 5000.0,
          date: DateTime.now().subtract(const Duration(days: 4)),
        ),
      ],
    ),
    FestivalFund(
      id: 'ff-2',
      title: 'Diwali Lighting & Fireworks Show',
      description:
          'Illumination of building facade, community Rangoli competition, and green fireworks display.',
      targetAmount: 80000.0,
      collectedAmount: 34000.0,
      endDate: DateTime.now().add(const Duration(days: 60)),
      contributions: [],
    ),
  ];

  // Pre-seeded Amenities
  static final List<Amenity> initialAmenities = const [
    Amenity(
      id: 'am-1',
      name: 'Clubhouse Auditorium',
      description: 'Air-conditioned hall with 100 capacity, sound system & projector.',
      iconName: 'home_work',
      rules: 'Max booking 6 hours. Cleanliness deposit required.',
      maxCapacity: 100,
    ),
    Amenity(
      id: 'am-2',
      name: 'Swimming Pool & Deck',
      description: 'Half-olympic pool with kids splash area and lounger chairs.',
      iconName: 'pool',
      rules: 'Proper swimwear mandatory. Children under 10 must be accompanied.',
      maxCapacity: 25,
    ),
    Amenity(
      id: 'am-3',
      name: 'Fitness Gym & Yoga Studio',
      description: 'Fully equipped cardio & weight lifting area + quiet yoga space.',
      iconName: 'fitness_center',
      rules: 'Sports shoes required. Limit 1 hour per session.',
      maxCapacity: 15,
    ),
    Amenity(
      id: 'am-4',
      name: 'Badminton Court',
      description: 'Indoor wooden court with LED lighting.',
      iconName: 'sports_tennis',
      rules: 'Non-marking shoes mandatory.',
      maxCapacity: 4,
    ),
  ];

  // Pre-seeded Amenity Bookings
  static final List<AmenityBooking> initialAmenityBookings = [
    AmenityBooking(
      id: 'ab-1',
      amenityId: 'am-1',
      amenityName: 'Clubhouse Auditorium',
      userId: 'u-3',
      userName: 'Rajesh Sharma',
      flatNumber: 'A-101',
      bookingDate: DateTime.now().add(const Duration(days: 3)),
      startTime: '05:00 PM',
      endTime: '09:00 PM',
      status: BookingStatus.confirmed,
    ),
    AmenityBooking(
      id: 'ab-2',
      amenityId: 'am-4',
      amenityName: 'Badminton Court',
      userId: 'u-4',
      userName: 'Priya Patel',
      flatNumber: 'B-201',
      bookingDate: DateTime.now().add(const Duration(days: 1)),
      startTime: '07:00 AM',
      endTime: '08:00 AM',
      status: BookingStatus.confirmed,
    ),
  ];

  // Pre-seeded Complaints
  static final List<Complaint> initialComplaints = [
    Complaint(
      id: 'c-1',
      title: 'Low Water Pressure in Master Washroom',
      description:
          'Water pressure in A-Wing 1st floor flats is very low since yesterday morning.',
      category: ComplaintCategory.plumbing,
      priority: PriorityLevel.high,
      status: ComplaintStatus.inProgress,
      createdBy: 'Rajesh Sharma',
      flatNumber: 'A-101',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      assignedTechnician: 'Ramesh Plumber (+91 98999 11111)',
      timeline: [
        TimelineEntry(
          title: 'Ticket Raised',
          description: 'Complaint submitted by Rajesh Sharma',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        ),
        TimelineEntry(
          title: 'Technician Assigned',
          description: 'Assigned to Ramesh Plumber by Secretary',
          timestamp: DateTime.now().subtract(const Duration(hours: 18)),
        ),
      ],
      comments: [
        ComplaintComment(
          id: 'cm-1',
          authorName: 'Suresh Mehta',
          authorRole: 'Secretary',
          message: 'Technician has been notified and will visit by 2:00 PM today.',
          timestamp: DateTime.now().subtract(const Duration(hours: 18)),
        ),
        ComplaintComment(
          id: 'cm-2',
          authorName: 'Rajesh Sharma',
          authorRole: 'Resident',
          message: 'Thank you! Please ensure the overhead valve is checked.',
          timestamp: DateTime.now().subtract(const Duration(hours: 16)),
        ),
      ],
    ),
    Complaint(
      id: 'c-2',
      title: 'Corridor Light Bulb Flicker B-Wing 2nd Floor',
      description:
          'The tube light right outside flat B-201 keeps flickering and flicked off.',
      category: ComplaintCategory.electrical,
      priority: PriorityLevel.medium,
      status: ComplaintStatus.open,
      createdBy: 'Priya Patel',
      flatNumber: 'B-201',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      timeline: [
        TimelineEntry(
          title: 'Ticket Raised',
          description: 'Complaint submitted by Priya Patel',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ],
      comments: [],
    ),
  ];

  // Pre-seeded NOC Requests
  static final List<NocRequest> initialNocRequests = [
    NocRequest(
      id: 'noc-1',
      flatNumber: 'B-201',
      applicantName: 'Priya Patel',
      tenantName: 'Vikram Joshi (Software Engineer at TCS)',
      purpose: 'Tenant Rental Leave & License Agreement (11 Months)',
      status: NocStatus.pending,
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NocRequest(
      id: 'noc-2',
      flatNumber: 'A-101',
      applicantName: 'Rajesh Sharma',
      tenantName: 'Kunal Shah',
      purpose: 'Flat Renting NOC',
      status: NocStatus.approved,
      requestDate: DateTime.now().subtract(const Duration(days: 30)),
      secretaryRemarks: 'Police verification and agreement copy verified.',
      approvedBy: 'Suresh Mehta',
    ),
  ];

  // Pre-seeded Resident Members
  static final List<ResidentMember> initialMembers = const [
    ResidentMember(
      id: 'rm-1',
      name: 'Rajesh Sharma',
      flatNumber: 'A-101',
      block: 'Wing A',
      phone: '+91 98765 11111',
      email: 'rajesh.sharma@example.com',
      type: ResidentType.owner,
    ),
    ResidentMember(
      id: 'rm-2',
      name: 'Priya Patel',
      flatNumber: 'B-201',
      block: 'Wing B',
      phone: '+91 98765 22222',
      email: 'priya.patel@example.com',
      type: ResidentType.owner,
    ),
    ResidentMember(
      id: 'rm-3',
      name: 'Suresh Mehta',
      flatNumber: 'C-302',
      block: 'Wing C',
      phone: '+91 98765 00002',
      email: 'secretary@greenvalley.org',
      type: ResidentType.owner,
    ),
    ResidentMember(
      id: 'rm-4',
      name: 'Kunal Shah',
      flatNumber: 'A-101',
      block: 'Wing A',
      phone: '+91 99887 76655',
      email: 'kunal.shah@example.com',
      type: ResidentType.tenant,
    ),
  ];

  // Pre-seeded Staff Workers
  static final List<StaffWorker> initialStaff = const [
    StaffWorker(
      id: 'sw-1',
      name: 'Ram Singh',
      role: StaffRole.guard,
      phone: '+91 98990 00111',
      shift: 'Day Shift',
      timing: '08:00 AM - 08:00 PM',
      rating: 4.8,
    ),
    StaffWorker(
      id: 'sw-2',
      name: 'Bahadur Thapa',
      role: StaffRole.guard,
      phone: '+91 98990 00222',
      shift: 'Night Shift',
      timing: '08:00 PM - 08:00 AM',
      rating: 4.9,
    ),
    StaffWorker(
      id: 'sw-3',
      name: 'Ramesh Kumar',
      role: StaffRole.plumber,
      phone: '+91 98999 11111',
      shift: 'On Call',
      timing: '09:00 AM - 06:00 PM',
      rating: 4.6,
    ),
    StaffWorker(
      id: 'sw-4',
      name: 'Sunita Devi',
      role: StaffRole.sweeper,
      phone: '+91 98999 22222',
      shift: 'Morning',
      timing: '07:00 AM - 01:00 PM',
      rating: 4.7,
    ),
    StaffWorker(
      id: 'sw-5',
      name: 'Mahesh Gardener',
      role: StaffRole.gardener,
      phone: '+91 98999 33333',
      shift: 'Alternate Days',
      timing: '08:00 AM - 12:00 PM',
      rating: 4.5,
    ),
  ];
}
