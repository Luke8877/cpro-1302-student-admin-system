# Project Structure Overview (CPRO 1302)

## Goal

Build a modular PL/SQL system for:

- Enrollment management  
- Academic reporting  
- Assessment and grade management  

This repository is structured to keep logic organized and avoid one large SQL file.

---

## Folder Structure

### `/packages`

Main implementation of logic.  
Each module will be implemented as a PL/SQL package.

- `enrollment_pkg.sql`
- `reporting_pkg.sql`
- `assessment_pkg.sql`

> Final logic should live here.

---

### `/procedures`


- `enroll_student_in_class.sql`
- `show_missing_grades.sql`

> These may be moved into packages later.

---

### `/functions`

#### `/public`

Standalone or reusable functions:

- `convert_grade.sql`
- `count_classes_per_course.sql`

#### `/private`

Helper functions intended to live inside packages:

- `compute_average_grade.sql`

---

### `/triggers`

Contains database triggers:

- `audit_grade_change.sql`

---

### `/sql/init`

Setup for required objects not provided in schema:

- Sequence: `ASSESSMENT_ID_SEQ`
- Table: `GRADE_CHANGE_HISTORY`

---

### `/sql/run_all.sql`

Master script to:

1. Initialize required objects  
2. Compile packages  
3. Create triggers  
4. Run test cases  

---

### `/tests`

Used to demonstrate functionality:

- `success_cases.sql`
- `error_cases.sql`

---

### `/docs`

Project documentation:

- `report.md` → final report   
- `notes.md` → planning and structure   

---

## Development Plan

1. Each module will be developed separately:
   - Enrollment  
   - Reporting  
   - Assessment  

2. All logic will be implemented inside packages  

3. Test cases will be written alongside development  

---
 
# Project Task Breakdown

## Luke

I will handle the **Enrollment module**, including:

- `enroll_student_in_class`
- `drop_student_from_class`
- `student_class_list` (both versions)
- `enrollment_pkg`

This section focuses on the **main logic and validation**.

---

## Jaren

### Reporting

- `show_missing_grades`
- `show_class_offerings`
- `count_classes_per_course`
- `compute_average_grade`
- `reporting_pkg`

### Assessment

- `create_assignment`
- `enter_student_grade`
- `convert_grade`
- `assessment_pkg`

---

## We will just do these as needed 

We will complete these together:

- Trigger:
  - `audit_grade_change`

- Required objects:
  - Sequence
  - Audit table

- Testing:
  - Success cases
  - Error cases

- Final files:
  - `run_all.sql`
  - Final report
