---
name: PlantUML Diagrams
description: UML diagrams using PlantUML syntax
---

# PlantUML Diagrams

PlantUML provides UML diagram support beyond Mermaid, with extensive diagram types and customization options.

## Basic Usage

````markdown
```plantuml
@startuml
Alice -> Bob: Hello
Bob --> Alice: Hi
@enduml
```
````

## Sequence Diagrams

````markdown
```plantuml
@startuml
participant Client
participant Server
participant Database

Client -> Server: Request
activate Server
Server -> Database: Query
activate Database
Database --> Server: Results
deactivate Database
Server --> Client: Response
deactivate Server
@enduml
```
````

## Class Diagrams

````markdown
```plantuml
@startuml
class User {
  +String name
  +String email
  +login()
  +logout()
}

class Order {
  +Date created
  +Decimal total
  +submit()
}

User "1" -- "*" Order : places
@enduml
```
````

## Activity Diagrams

````markdown
```plantuml
@startuml
start
:Initialize;
if (Valid?) then (yes)
  :Process;
  :Save;
else (no)
  :Show Error;
endif
stop
@enduml
```
````

## Component Diagrams

````markdown
```plantuml
@startuml
package "Frontend" {
  [React App]
  [State Management]
}

package "Backend" {
  [API Server]
  [Auth Service]
}

database "Database" {
  [PostgreSQL]
}

[React App] --> [API Server]
[API Server] --> [PostgreSQL]
[API Server] --> [Auth Service]
@enduml
```
````

## State Diagrams

````markdown
```plantuml
@startuml
[*] --> Idle
Idle --> Processing : start
Processing --> Completed : success
Processing --> Failed : error
Completed --> [*]
Failed --> Idle : retry
@enduml
```
````

## Styling

````markdown
```plantuml
@startuml
skinparam backgroundColor #EEEEEE
skinparam handwritten true

skinparam sequence {
  ArrowColor #333333
  LifeLineBorderColor #666666
  ParticipantBackgroundColor #FFFFFF
}

Alice -> Bob: Styled message
@enduml
```
````

## Common Skinparams

| Parameter | Description |
|-----------|-------------|
| `backgroundColor` | Background color |
| `handwritten` | Hand-drawn style |
| `monochrome` | Black and white |
| `shadowing` | Enable shadows |

## When to Use PlantUML vs Mermaid

| Use PlantUML | Use Mermaid |
|--------------|-------------|
| Complex UML diagrams | Simple flowcharts |
| Detailed class relationships | Quick sequence diagrams |
| Activity diagrams with lanes | Gantt charts |
| Deployment diagrams | Git graphs |
| When you need skinparams | When you want simpler syntax |

## Setup

PlantUML requires Java or the PlantUML server. Slidev typically uses the PlantUML server automatically.
