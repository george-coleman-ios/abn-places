# abn-places

Things I would do if I had more time:
- PlacesViewController is a behemoth of a class. I wanted to write a test for showCoordinate (the method I added) but there is currently no test infrastructure in place and all business logic is written in the VC. To write tests for this class a significant refactor of the class is needed. This felt out of scope for this assignment. 
- 

Things to consider: 
- Endpoint.swift is currently pretty barebones and only works for GET requests. Initially I wrote an API layer which was capable of more HTTP methods, including headers and query parameters but decided to scratch that for a simpler, more to the point implementation where every line of code actually gets used.
