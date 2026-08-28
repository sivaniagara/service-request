dynamic userData = {
  "user_id": "BIGINT",
  "name": "VARCHAR(100)",
  "mobile_number": "VARCHAR(15)",
  "role": "Admin",
  "address": "TEXT",
  "city": "VARCHAR(100)",
  "state": "VARCHAR(100)",
  "pincode": "VARCHAR(10)",
  "is_active": "BOOLEAN",
  "created_by": "BIGINT",
  "updated_by": "BIGINT",
  "created_at": "DATETIME",
  "updated_at": "DATETIME"
};


dynamic ticket = {
  "id": "BIGINT",
  "customer_id": "BIGINT",
  "alt_mobile_number": "TEXT",
  "description": "TEXT",
  "status": "ENUM('CUSTOMER_RAISED','ADMIN_REVIEW','ASSIGNED_TO_DEALER','ASSIGNED_TO_SERVICE_PERSON','ACCEPTED','TRAVELING','ON_SITE','WORK_IN_PROGRESS','RESOLVED','CLOSED','ON_HOLD','CANCELLED','ESCALATED')",
  "issue_type": "TEXT",
  "priority": "ENUM('LOW','NORMAL','HIGH','URGENT')",
  "address": "TEXT",
  "image_path": "TEXT",
  "latitude": "DECIMAL(10,7)",
  "longitude": "DECIMAL(10,7)",
  "created_at": "DATETIME",
  "updated_at": "DATETIME"
};

dynamic ticket_issue_types = {
  "id": "BIGINT PRIMARY KEY",
  "ticket_id": "BIGINT FOREIGN KEY",
  "issue_type_id": "BIGINT FOREIGN KEY"
};


dynamic  ticket_assignments = {
  "id": "BIGINT PRIMARY KEY",
  "ticket_id": "BIGINT FOREIGN KEY",
  "dealer_id": "BIGINT FOREIGN KEY",
  "service_person_id": "BIGINT FOREIGN KEY",
  "assigned_by": "BIGINT FOREIGN KEY",
  "assignment_type": "ENUM",
  "assigned_at": "DATETIME",
  "unassigned_at": "DATETIME",
  "is_current": "BOOLEAN"
};


dynamic ticket_timeline = {
  "id": "BIGINT PRIMARY KEY",
  "ticket_id": "BIGINT FOREIGN KEY",
  "event_type": "VARCHAR(50)",
  "message": "TEXT",
  "performed_by": "BIGINT FOREIGN KEY",
  "created_at": "DATETIME"
};


dynamic ticket_services = {
  "id": "BIGINT PRIMARY KEY",
  "ticket_id": "BIGINT FOREIGN KEY",
  "service_person_id": "BIGINT FOREIGN KEY",
  "service_mode": "ENUM",
  "accepted_at": "DATETIME",
  "travel_started_at": "DATETIME",
  "site_checkin_at": "DATETIME",
  "checkin_latitude": "DECIMAL(10,7)",
  "checkin_longitude": "DECIMAL(10,7)",
  "work_started_at": "DATETIME",
  "work_completed_at": "DATETIME",
  "root_cause": "TEXT",
  "work_description": "TEXT",
  "resolved_at": "DATETIME"
};


dynamic ticket_attachments = {
  "id": "BIGINT PRIMARY KEY",
  "ticket_id": "BIGINT FOREIGN KEY",
  "uploaded_by": "BIGINT FOREIGN KEY",
  "file_url": "TEXT",
  "file_type": "VARCHAR(50)",
  "created_at": "DATETIME"
};


dynamic  ticket_appointments = {
  "id": "BIGINT PRIMARY KEY",
  "ticket_id": "BIGINT FOREIGN KEY",
  "service_person_id": "BIGINT FOREIGN KEY",
  "scheduled_date": "DATE",
  "start_time": "TIME",
  "end_time": "TIME",
  "reason": "TEXT",
  "created_by": "BIGINT FOREIGN KEY",
  "created_at": "DATETIME"
};



dynamic main_relationship = {
  "customer": "customers.id -> tickets.customer_id",
  "ticket_issue": "tickets.id -> ticket_issue_types.ticket_id",
  "ticket_dealer": "dealers.id -> ticket_assignments.dealer_id",
  "ticket_service_person": "service_persons.id -> ticket_assignments.service_person_id",
  "ticket_timeline": "tickets.id -> ticket_timeline.ticket_id",
  "ticket_service": "tickets.id -> ticket_services.ticket_id",
  "ticket_attachments": "tickets.id -> ticket_attachments.ticket_id",
  "ticket_appointments": "tickets.id -> ticket_appointments.ticket_id"
};

/*
*
* */



dynamic data = {
  'tickedId' : 1,
  'name': 'siva',
  'mobileNumber': '9876543210',
  'issueDescription' : '',
  'issueType' : [
    {
      'sNo': 1,
      'type': 'Application',
      'value': false
    },
    {
      'sNo': 2,
      'type': 'Hardware',
      'value': false
    },
    {
      'sNo': 2,
      'type': 'Valve',
      'value': false
    },
    {
      'sNo': 2,
      'type': 'Filter',
      'value': false
    },
    {
      'sNo': 2,
      'type': 'Fertilizer',
      'value': false
    },
    {
      'sNo': 2,
      'type': 'Sensors',
      'value': false
    },
    {
      'sNo': 2,
      'type': 'Others',
      'value': false
    },
  ],
  'issueStatus': [
    {
      'sNo': 1,
      'name': 'Customer Raised Complaint',
      'value': false,
      'display': false
    },
    {
      'sNo': 1,
      'name': 'Ticket Responsible Person',
      'value': false,
      'display': false
    },
    {
      'sNo': 1,
      'name': 'Escalated to the company',
      'value': false,
      'display': false
    },
    {
      'sNo': 1,
      'name': 'Ticket Closed',
      'value': false,
      'display': false
    },
  ],
  'ticketHandler': [
    {
      'sNo': 1,
      'name': 'Saravanan',
      'mobileNumber': '',
      'statusMessage': '',
      'targetDates': [
        {
          'date': '',
          'reason': ''
        },
        {
          'date': '',
          'reason': ''
        },
      ],
      'salesPerson': [
        {
          'sNo': 1,
          'name': 'Saravanan',
          'mobileNumber': '',
          'statusMessage': '',
        }
      ]
    }
  ]
};
