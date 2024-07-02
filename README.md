# Habits Backend

## Overview
The Habits Backend is a Rails-based API designed to deliver data for a Next.js
frontend application. This project manages user to-dos, allowing them to be
scheduled and set on a recurring basis using the [RRule][rrule] specification.

## Features
- CRUD operations for tasks
- Schedule tasks with specific dates and times
- Recurring tasks using the RRule specification
- API endpoints to support Next.js frontend

## Getting Started

### Prerequisites
- Ruby 3.x
- Rails 6.x or 7.x
- PostgreSQL

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/danfrenette/habits-backend.git
   cd habits-backend
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the server:
   ```bash
   bin/dev
   ```

### API Endpoints

api_user_tasks  POST  /api/users/:user_id/tasks(.:format)                                                               api/tasks#create
api_users       POST  /api/users(.:format)                                                                              api/users#create
api_tasks       GET   /api/tasks(.:format)                                                                              api/tasks#index
api_task        PATCH /api/tasks/:id(.:format)                                                                          api/tasks#update
                PUT   /api/tasks/:id(.:format)

* Note that some endpoints may be present in main, but are for features
  currently being developed for the Frontend.

## Usage
This API is designed to be used with the Next.js frontend. For details on
integrating with the frontend, refer to the frontend repository.

## Contributing
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a new Pull Request.

## Contact
For any inquiries, [send me an email yourname](mailto:dan.r.frenette@gmail.com).

[rrule]: https://icalendar.org/iCalendar-RFC-5545/3-8-5-3-recurrence-rule.html
