Everyone is in attendance!

Feedback on MVP
Just checking that we hit all the goals we set earlier
- Sign up, create questions, open questions, accept responses, view results
- Good job! We hit our core goals
- Suggestions: font color should not be white; more contrasting colors for projector

Improving analytics
- See answers by student, and allow students to view their own responses
- Maybe look at other similar apps and how they are solving problems
	Like Gradebook 
- Helpful to talk to people at edX: what kind of analytics do they think are important?

Improving questions
- LaTeX for equations
- Images

Talk to more end-users, ask them what they would like to see
- Help us narrow down our priorities
- Set up meeting with Belcher ASAP
- Do some user testing

Feedback on Design Doc
Data Model
- Multiplicity between students and responses seems wrong
Add textual constraint instead that for each question, a student can only have one response
- Split up state machine flow and wireframes themselves
- Add standard Rails mitigations (SQL injection, CSRF, etc.)
- Make it more clear that the mobile part is not separate
- Use email confirmation to check that users are in the class, authentication
	devise gem

More suggestions from Carolyn
- Adding classes: autocomplete, enter should submit form
- Label table headers (make it clearer what the phone number is for)
- Improve student interface
- Make it clearer that add instructor button is connected with the form field
- Delete course should be less prominent
- Change color of the bars

Next steps
- We want to mostly finish by 12/1 so we can spend the last week refining and testing
