**Project Overview**
TaskCatchup is a gamified, all-in-one productivity and scheduling iOS application. It is engineered to help busy university students seamlessly integrate their fixed commitments such as lectures, work shifts, or social events, with flexible daily goals such as study sessions, self-care, or daily accomplishment into a single, unified timeline. By utilising a dual-reward points gamification system (Lifetime XP and Balance Points), the app rewards both productivity and rest to actively provide motivation and prevent burnout.

**Domain Context**
The primary stakeholder for this application is a university student balancing full-time academics with part-time employment.
Research indicates that managing conflicting schedules across multiple apps is a primary driver of psychological distress and cognitive overload for young university students.

**Architecture Summary**
This application strictly follows MVVM (Model-View-ViewModel) combined with Clean Architecture / Domain-Driven Design principles: Presentation Layer, Use Case Layer, Domain Models, Database Layer (Core Data) 

**Database Choice**
Core Data was selected as the persistent database. This decision was driven by the domain constraints of privacy, speed, and offline reliability. A student's schedule and mental health management data are highly personal and do not require cloud sharing. Furthermore, students frequently navigate university campuses and public transit with poor or no Wi-Fi. Core Data ensures that gamification progress is saved instantly and reliably with zero network latency.

**Chosen Extensions & Justification**
*WidgetKit Widget Extension*
- Justification: When a student is studying, unlocking their phone to check a task manager introduces a high risk of digital distraction, such as from social media. The Widget solves this by providing glanceable data that show Profile Stats, and remaining imcompleted goals directly on the Home or Lock Screen, reducing friction and maintaining focus.
*Notification Content Extension*
- Justification: Students easily ignore generic text alerts. To prevent them from losing their daily habit streak, TaskCatchup utilises a rich Notification Content Extension. When the student long-presses the daily "Plan Your Day" reminder, a custom SwiftUI view expands to show their current flame streak and gamification level, using loss-aversion psychology to motivate them to open the app.

**App Group Identifier**
Data is shared securely between the main application and the system extensions using the following App Group shared container:
*group.com.bowen.TaskCatchup*

**Setup Instructions**
1. Clone this repository to your local machine.
2. Open TaskCatchupV2.xcodeproj in Xcode 16 or newer.
3. In the Project Navigator, select the top-level TaskCatchupV2 project file.
4. Navigate to Signing & Capabilities for all three targets (TaskCatchupV2, TaskCatchupWidgets, and TaskCatchupNotification).
5. Ensure your personal Apple Developer Team is selected, and verify that the App Group identifier is checked and active (no red text).
6. Select the TaskCatchupV2 scheme at the top of Xcode and press Cmd + R to build and run the application in the iOS Simulator.
