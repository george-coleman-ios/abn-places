# ABN places tech assignment

Architecture choice: 
For this project I decided to use clean architecture. In my opinion, predictability, testability and maintainability are the most important features of a good code base and clean architecture forces us as developers to adhere to these principles more or less automatically. I have organised the project by feature. These features should all hold the same three internal layers, namely 

- Data: this is, as the name suggests, the part of the app where the raw data gets handled. Repositories communicate with the API layer, decode JSONs into data transfer objects (DTOs) and map these into domain models. 
- Domain: this is where the business logic lives. It defines what it needs (through protocols) and does work through use cases. Everything in this layer should _always_ be unit tested. 
- Presentation: this is where the UI lives. It consists of ViewModels which take the output of the usecases and manipulates this output into data which can be displayed by the Views. It communicates state changes to the Views reactively. Everything in the presentation layer should be @MainActor. 

The data layer only communicates to the Domain layer, which only communicates to the Presentation layer. For requests this communication flows the other way.

Things I would do if I had more time:
- In the Wikipedia app: PlacesViewController is a behemoth of a class. I wanted to write a test for showCoordinate (the method I added) but there is currently no test infrastructure in place and all business logic is written in the VC. To write tests for this class a significant refactor of the class is needed. This felt out of scope for this assignment. 
- In the places app: I currently have no persistence of any kind. This is not necessarily skipped due to time constraints, but because I feel like it's important to stick to the brief of the assignment and not expand beyond it. If this was a project within ABN, with a product owner and a UX designer, this would be something that I would discuss with them before making a decision. 
- In any application with UI I generally really like adding screenshot tests, however since this project has no dependencies I didn't feel like introducing the snapshot-testing library was appropriate.

Things to consider: 
- Endpoint.swift is currently pretty barebones and only works for GET requests. Initially I wrote an API layer which was capable of more HTTP methods, including headers and query parameters but decided to scratch that for a simpler, more to the point implementation where every line of code actually gets used.
- I originally planned to write UITests for the Places app as well, but considering the end result I felt like there is very little that UITests would add that is not already covered by unit tests. The framework is still there to add UITests if the app were to grow to contain multiple screens in the future.
